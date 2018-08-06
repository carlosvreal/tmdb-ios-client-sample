//
//  MoviesViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

final class MoviesViewModel {
  var moviesDataSource: Driver<[MovieViewModel]> {
    return dataSource.asDriver()
  }
    
  let dataSource = Variable<[MovieViewModel]>([])
  let nextPage = PublishSubject<Void>()
  let errorMessage = PublishSubject<String>()
  let isLoading = PublishSubject<Bool>()
  private var page = 0
  private let service: MoviesServiceProtocol
  private let disposeBag: DisposeBag
  
  init(service: MoviesServiceProtocol = MoviesServiceProvider()) {
    self.service = service
    self.disposeBag = DisposeBag()
    
    setupServiceCalls()
    
    // load the fist page
    nextPage.onNext(())
  }
}

// MARK: Setup observables
private extension MoviesViewModel {
  func setupServiceCalls() {
    let paginator = self.nextPage
      .flatMapLatest { [weak self] _ -> Observable<Int> in
        guard let strongSelf = self else { return .just(1) }
        strongSelf.page += 1
        return .just(strongSelf.page)
      }

    let moviesObservable = paginator
      .distinctUntilChanged()
      .flatMap { [weak self] page -> Observable<[MovieViewModel]> in
        guard let strongSelf = self else { return .just([]) }
        return strongSelf.loadMovies(from: page)
    }
    
    moviesObservable.bind(to: dataSource).disposed(by: disposeBag)
  }
  
  func loadMovies(from page: Int) -> Observable<[MovieViewModel]> {
    isLoading.onNext(true)
    
    let fetchMovies = service.fetchMovies(from: page)
      .asObservable().debounce(1, scheduler: MainScheduler.asyncInstance)
    let genres = service.genres().asObservable()
    
    return Observable.zip(fetchMovies, genres) { ($0, $1) }
      .filter { page <= $0.0.totalPages }
      .map { (movies, genres) -> [MovieViewModel] in
        return movies.results.map { movie -> MovieViewModel in
          let movieGenres = movie.genreIds?.map { id -> Genre? in
            return genres.first(where: { $0.id == id })
            }.compactMap { $0 }
          
          return MovieViewModel(title: movie.title,
                                imagePath: movie.poster,
                                ratingScore: movie.rating,
                                releaseYear: movie.releaseDate,
                                genres: movieGenres)
        }
      }.scan(dataSource.value) { (currentMovies, newMovies) -> [MovieViewModel] in
        return currentMovies + newMovies
      }.do(onNext: { [weak self] _ in
        self?.isLoading.onNext(false)
        }, onError: { [weak self] error in
          self?.isLoading.onNext(false)
          self?.errorMessage.onNext(error.localizedDescription)
      })
  }
}
