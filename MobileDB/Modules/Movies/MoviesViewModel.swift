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
  var moviesDataSource: Driver<[MovieDetailModel]> {
    return dataSource.asDriver()
  }

  let dataSource = Variable<[MovieDetailModel]>([])
  let refresh = PublishSubject<Void>()
  let nextPage = PublishSubject<Void>()
  let loadMovieId = PublishSubject<String>()
  let errorMessage = PublishSubject<String>()
  let isLoadingData = PublishSubject<Bool>()
  let movieDetail = PublishSubject<MovieDetailModel>()
  
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
    
    // Load movie detail
    loadMovieId
      .flatMap { [weak self] id -> Observable<MovieDetailModel> in
        guard let strongSelf = self else { return .error(ServiceError.invalidParameters(message: "Invalid Movie id")) }
        return strongSelf.loadMovieDetail(with: id)
      }.bind(to: movieDetail)
      .disposed(by: disposeBag)
    
    // Refresh
    refresh
      .flatMap { [weak self] page -> Observable<[MovieDetailModel]> in
        guard let strongSelf = self else { return .just([]) }
        strongSelf.dataSource.value.removeAll()
        strongSelf.page = 1
        return strongSelf.loadMovies(from: strongSelf.page)
      }.bind(to: dataSource)
      .disposed(by: disposeBag)
    
    // Pagination
    let paginator = self.nextPage
      .flatMapLatest { [weak self] _ -> Observable<Int> in
        guard let strongSelf = self else { return .just(1) }
        strongSelf.page += 1
        return .just(strongSelf.page)
      }

    let moviesObservable = paginator
      .distinctUntilChanged()
      .flatMap { [weak self] page -> Observable<[MovieDetailModel]> in
        guard let strongSelf = self else { return .just([]) }
        return strongSelf.loadMovies(from: page)
    }
    
    moviesObservable.bind(to: dataSource).disposed(by: disposeBag)
  }
  
  func loadMovieDetail(with identifier: String) -> Observable<MovieDetailModel> {
    return service.fetchMovieDetail(with: identifier).asObservable()
      .map { movie -> MovieDetailModel in
        return MovieDetailModel(id: movie.id,
                                title: movie.title,
                                posterImagePath: movie.poster,
                                backdropImagePath: movie.backdrop,
                                ratingScore: movie.rating,
                                releaseYear: movie.releaseDate,
                                genres: movie.genres,
                                revenue: movie.revenue,
                                description: movie.description,
                                runtime: movie.runtime,
                                language: movie.spokenLanguage?.first?.name,
                                homepageLink: movie.homepage)
    }
  }
  
  func loadMovies(from page: Int) -> Observable<[MovieDetailModel]> {
    isLoadingData.onNext(true)
    
    let fetchMovies = service.fetchMovies(from: page)
      .asObservable().debounce(1, scheduler: MainScheduler.asyncInstance)
    let genres = service.genres().asObservable()
    
    return Observable.zip(fetchMovies, genres) { ($0, $1) }
      .filter { page <= $0.0.totalPages }
      .map { [weak self] (movies, genres) -> [MovieDetailModel] in
        guard let strongSelf = self else { return [] }
        return strongSelf.mapMoviesGenresToMovieDetail(movies: movies, genres: genres)
      }.scan(dataSource.value) { (currentMovies, newMovies) -> [MovieDetailModel] in
        return currentMovies + newMovies
      }.do(onNext: { [weak self] _ in
        self?.isLoadingData.onNext(false)
        }, onError: { [weak self] error in
          self?.isLoadingData.onNext(false)
          self?.errorMessage.onNext(error.localizedDescription)
      })
  }
  
  func mapMoviesGenresToMovieDetail(movies: Movies, genres: [Genre]) -> [MovieDetailModel] {
    return movies.results.map { movie -> MovieDetailModel in
      let movieGenres = movie.genreIds?.map { id -> Genre? in
        return genres.first(where: { $0.id == id })
        }.compactMap { $0 }
      
      return MovieDetailModel(id: movie.id,
                              title: movie.title,
                              posterImagePath: movie.poster,
                              backdropImagePath: movie.backdrop,
                              ratingScore: movie.rating,
                              releaseYear: movie.releaseDate,
                              genres: movieGenres,
                              revenue: movie.revenue,
                              description: movie.description,
                              runtime: movie.runtime,
                              language: movie.language,
                              homepageLink: movie.homepage)
    }
  }
}
