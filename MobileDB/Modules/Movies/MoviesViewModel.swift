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
  private let dataSource = Variable<[MovieViewModel]>([])
  private var page = 1
  private var cachedGenres = Variable<[Genre]>([])
  let errorMessage = PublishSubject<String>()
  let isLoading = PublishSubject<Bool>()
  
  var moviesDataSource: Driver<[MovieViewModel]> {
    return dataSource.asDriver()
  }
  
  private let service: MoviesServiceProtocol
  private let disposeBag: DisposeBag
  
  init(service: MoviesServiceProtocol = MoviesServiceProvider()) {
    self.service = service
    self.disposeBag = DisposeBag()
    
    nextPage()
  }
  
  func nextPage() {
    isLoading.onNext(true)
    
    let fetchMovies = service.fetchMovies(from: page)
    let genres = service.genres()
      .do(onSuccess: { [weak self] genres in
        self?.cachedGenres.value.append(contentsOf: genres)
      })
    
    Single.zip(fetchMovies, genres) { ($0, $1) }
      .map { (movies, genres) -> [MovieViewModel] in
        return movies.map { movie -> MovieViewModel in
          let movieGenres = movie.genreIds?.map { id -> Genre? in
            return genres.first(where: { $0.id == id })
            }.compactMap { $0 }
          
          return MovieViewModel(title: movie.title,
                                imagePath: movie.poster,
                                ratingScore: movie.rating,
                                releaseYear: movie.releaseDate,
                                genres: movieGenres)
        }
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onSuccess: { [unowned self] movies in
        self.dataSource.value.append(contentsOf: movies)
        self.page += 1
        self.isLoading.onNext(false)
      }, onError: { [unowned self] error in
        self.isLoading.onNext(false)
        self.errorMessage.onNext(error.localizedDescription)
      }).disposed(by: disposeBag)
  }
}
