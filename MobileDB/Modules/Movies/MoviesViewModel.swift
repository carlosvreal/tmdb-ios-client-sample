//
//  MoviesViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MoviesViewModelType {
  var dataSource: Driver<[MovieViewData]> { get }
  var movieDetail: Driver<MovieViewData> { get }
  var isLoadingData: Driver<Bool> { get }
  var errorMessage: Driver<String?> { get }
  
  func bindLoadFirstPage(to observable: Observable<Void>) -> Disposable
  func bindLoadNextPage(to observable: Observable<Void>) -> Disposable
  func bindSearchMovies(to observable: Observable<String>) -> Disposable
  func bindLoadMovieDetail(to observable: Observable<MovieViewData>) -> Disposable
  func bindResetData(to observable: Observable<Void>) -> Disposable
  func bindRefresh(to observable: Observable<Void>) -> Disposable
}

struct MoviesViewModel {
  private typealias Copies = Strings.Error
  
  private let errorMessageSubject = PublishSubject<String?>()
  private let isLoadingDataSubject = PublishSubject<Bool>()
  private let didReceiveMovieDetailSubject = PublishSubject<MovieViewData>()
  private let searchMovieQuery = BehaviorSubject<String?>(value: nil)
  
  private let dataSourceRelay = BehaviorRelay<[MovieViewData]>(value: [])
  private var page = BehaviorRelay(value: 1)
  private var isSortedByPopularity = BehaviorRelay(value: true)
  private let service: MoviesServiceProtocol
  private let scheduler: SchedulerType
  
  init(service: MoviesServiceProtocol = MoviesServiceProvider(),
       scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
    self.service = service
    self.scheduler = scheduler
  }
}

// MARK: - MoviesViewModelType
extension MoviesViewModel: MoviesViewModelType {
  
  var dataSource: Driver<[MovieViewData]> {
    dataSourceRelay.asDriver()
  }
  var movieDetail: Driver<MovieViewData> {
    didReceiveMovieDetailSubject.asDriver(onErrorDriveWith: .empty())
  }
  var isLoadingData: Driver<Bool> {
    isLoadingDataSubject.asDriver(onErrorJustReturn: false)
  }
  var errorMessage: Driver<String?> {
    errorMessageSubject.asDriver(onErrorJustReturn: nil)
  }
  
  func bindLoadFirstPage(to observable: Observable<Void>) -> Disposable {
    observable
      .do(onNext: { _ in
        self.page.accept(1)
        self.dataSourceRelay.accept([])
      })
      .flatMapLatest { self.requestMovies() }
      .bind(to: dataSourceRelay)
  }
  
  func bindLoadNextPage(to observable: Observable<Void>) -> Disposable {
    observable
      .flatMapLatest { self.requestMovies() }
      .bind(to: dataSourceRelay)
  }
  
  func bindLoadMovieDetail(to observable: Observable<MovieViewData>) -> Disposable {
    observable
      .do(onNext: { _ in self.isLoadingDataSubject.onNext(true) })
      .compactMap { $0.id }
      .map { String(describing: $0) }
      .flatMapLatest { self.loadMovieDetail(with: $0) }
      .bind(to: didReceiveMovieDetailSubject)
  }
  
  func bindSearchMovies(to observable: Observable<String>) -> Disposable {
    observable
      .do(onNext: { _ in
        self.page.accept(1)
        self.isSortedByPopularity.accept(false)
        self.dataSourceRelay.accept([])
      })
      .flatMapLatest { self.requestMovies(query: $0) }
      .bind(to: dataSourceRelay)
  }
  
  func bindResetData(to observable: Observable<Void>) -> Disposable {
    observable
      .subscribe(onNext: { _ in
        self.page.accept(1)
        self.isSortedByPopularity.accept(true)
        self.dataSourceRelay.accept([])
      })
  }
  
  func bindRefresh(to observable: Observable<Void>) -> Disposable {
    observable
      .do(onNext: { _ in
        self.page.accept(1)
        self.isSortedByPopularity.accept(true)
        self.dataSourceRelay.accept([])
      })
      .flatMapLatest { self.requestMovies() }
      .bind(to: dataSourceRelay)
  }
}

// MARK: - Setup observables
private extension MoviesViewModel {
  func requestMovies(query: String? = nil) -> Single<[MovieViewData]> {
    loadMovies(by: query, from: self.page.value)
      .do(onNext: { _ in
        let nextPage = self.page.value + 1
        self.page.accept(nextPage)
      })
      .take(1)
      .asSingle()
  }
  
  func loadMovieDetail(with identifier: String) -> Observable<MovieViewData> {
    service
      .fetchMovieDetail(with: identifier).asObservable()
      .map { movie -> MovieViewData? in
        self.mapMovieToMovieViewData(movie: movie,
                                     genres: movie.genres,
                                     language: movie.spokenLanguage?.first?.name)
      }
      .compactMap { $0 }
      .do(onNext: { _ in self.isLoadingDataSubject.onNext(false) })
      .do(onError: { _ in
        self.isLoadingDataSubject.onNext(false)
        self.errorMessageSubject.onNext(Copies.requestFailed)
      })
  }
}

// MARK: - Load movies content
private extension MoviesViewModel {
  func loadMovies(by query: String? = nil, from page: Int) -> Observable<[MovieViewData]> {
    let genres = service.genres().asObservable()
    
    var moviesObservable: Observable<Movies>
    if let query = query, !query.isEmpty {
      moviesObservable = service.search(for: query, page: page).asObservable()
    } else {
      moviesObservable = service.fetchMovies(from: page).asObservable()
    }
    
    return loadMovies(moviesObservable, genres: genres)
  }
  
  func loadMovies(_ movies: Observable<Movies>, genres: Observable<[Genre]>) -> Observable<[MovieViewData]> {
    Observable.zip(movies, genres)
      .do(onNext: { _ in self.isLoadingDataSubject.onNext(true) })
      .filter { self.page.value <= $0.0.totalPages }
      .map { self.mapMoviesGenresToMovieViewData(movies: $0.0, genres: $0.1) }
      .scan(dataSourceRelay.value) { currentMovies, newMovies -> [MovieViewData] in
        guard self.isSortedByPopularity.value else {
          return currentMovies + newMovies
        }
        
        let sortedList = (currentMovies + newMovies)
          .sorted(by: { (movieA, movieB) -> Bool in
            return movieA.popularity > movieB.popularity
          })
        return sortedList
      }
      .catchError { _ -> Observable<[MovieViewData]> in
        self.isLoadingDataSubject.onNext(false)
        self.errorMessageSubject.onNext(Copies.requestFailed)
        return .empty()
      }
      .do(onNext: { _ in self.isLoadingDataSubject.onNext(false) })
      .do(onDispose: { self.isLoadingDataSubject.onNext(false) })
  }
}

// MARK: - Utility map methods
private extension MoviesViewModel {
  func mapMoviesGenresToMovieViewData(movies: Movies, genres: [Genre]) -> [MovieViewData] {
    movies
      .results
      .map { movie -> MovieViewData? in
        let movieGenres = movie.genreIds?.compactMap { id in genres.first(where: { $0.id == id }) }
        
        return self.mapMovieToMovieViewData(movie: movie,
                                            genres: movieGenres,
                                            language: movie.originalLanguage)
    }
    .compactMap { $0 }
  }
  
  func mapMovieToMovieViewData(movie: Movie, genres: [Genre]?, language: String?) -> MovieViewData? {
    MovieViewData(id: movie.id,
                  title: movie.title,
                  posterImagePath: movie.posterPath,
                  backdropImagePath: movie.backdropPath,
                  ratingScore: movie.rating,
                  releaseYear: movie.releaseDate,
                  genres: genres,
                  revenue: movie.revenue,
                  description: movie.overview,
                  runtime: movie.runtime,
                  language: language,
                  homepageLink: movie.homepage,
                  popularity: movie.popularity ?? 0)
  }
}
