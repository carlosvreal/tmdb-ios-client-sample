//
//  MoviesViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

private struct MoviesViewModelConstants {
  static let messageEmptySearch = "No movies found"
  static let invalidMovieId = "Invalid Movie id"
  static let requestFailed = "Something went wrong. Please try again"
}

final class MoviesViewModel {
  var moviesDataSource: Driver<[MovieViewData]> {
    return dataSource.asDriver()
  }
  
  let refresh = PublishSubject<Void>()
  let nextPage = PublishSubject<Void>()
  let willSearchMovieDetail = PublishSubject<String>()
  let errorMessage = PublishSubject<String>()
  let isLoadingData = PublishSubject<Bool>()
  let didReceiveMovieDetail = PublishSubject<MovieViewData>()
  let searchMovieQuery = BehaviorSubject<String?>(value: nil)
  let willCleanSearchResult = PublishSubject<Void>()
  let willCancelSearch = PublishSubject<Void>()
  
  private let dataSource = BehaviorRelay<[MovieViewData]>(value: [])
  private var page = 1
  private let service: MoviesServiceProtocol
  private let disposeBag = DisposeBag()
  private let scheduler: SchedulerType
  private var requestDispossble: Disposable? {
    didSet {
      oldValue?.dispose()
      requestDispossble?.disposed(by: disposeBag)
    }
  }
  
  init(service: MoviesServiceProtocol = MoviesServiceProvider(),
       scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
    
    self.service = service
    self.scheduler = scheduler
    
    setupServiceCalls()
    setupMovieDetail()
  }
  
  func loadMoviesList() {
    requestMoviesNew()
  }
}

// MARK: Setup observables
private extension MoviesViewModel {
  func requestMoviesNew(query: String? = nil) {
    requestDispossble = nil
    requestDispossble = nextPage.startWith(())
      .flatMapLatest { [weak self] page -> Observable<[MovieViewData]> in
        guard let strongSelf = self else { return .just([]) }
        return strongSelf.loadMovies(by: query, from: strongSelf.page)
          .do(onNext: { [weak self] _ in
            self?.page += 1
          })
      }.bind(to: dataSource)
  }
  
  func setupServiceCalls() {
    // Refresh
    refresh
      .skip(1)
      .subscribe(onNext: { [unowned self] _ in
        self.page = 1
        self.dataSource.accept([])
        self.requestMoviesNew()
      }).disposed(by: disposeBag)
    
    // Cancel search
    willCancelSearch.subscribe(onNext: { [unowned self] _ in
      self.page = 1
      self.dataSource.accept([])
      self.requestMoviesNew()
    }).disposed(by: disposeBag)
    
    willCleanSearchResult
      .skip(1)
      .subscribe(onNext: { [unowned self] in
        self.page = 1
        self.dataSource.accept([])
      }).disposed(by: disposeBag)
    
    searchMovieQuery
      .flatMap { Observable.from(optional: $0) }
      .filter { !$0.isEmpty }
      .debounce(0.3, scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self] query in
        self.page = 1
        self.dataSource.accept([])
        self.requestMoviesNew(query: query)
      }).disposed(by: disposeBag)
  }
}

// MARK: Movie Detail data

private extension MoviesViewModel {
  func setupMovieDetail() {
    // Load movie detail
    willSearchMovieDetail
      .flatMap { [unowned self] id -> Observable<MovieViewData> in
        return self.loadMovieDetail(with: id)
      }.bind(to: didReceiveMovieDetail)
      .disposed(by: disposeBag)
  }
  
  func loadMovieDetail(with identifier: String) -> Observable<MovieViewData> {
    isLoadingData.onNext(true)
    return service.fetchMovieDetail(with: identifier).asObservable()
      .map { [weak self] movie -> MovieViewData? in
        return self?.mapMovieToMovieViewData(movie: movie,
                                             genres: movie.genres,
                                             language: movie.spokenLanguage?.first?.name)
      }.flatMap { Observable.from(optional: $0) }
      .do(onNext: { [weak self] _ in
        self?.isLoadingData.onNext(false)
        }, onError: { [weak self] error in
          self?.isLoadingData.onNext(false)
          self?.errorMessage.onNext(error.localizedDescription)
      })
  }
}

// MARK: Load movies content
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
}

// MARK: Execute movies fetch
private extension MoviesViewModel {
  func loadMovies(_ movies: Observable<Movies>, genres: Observable<[Genre]>) -> Observable<[MovieViewData]> {
    isLoadingData.onNext(true)
    
    return Observable.zip(movies, genres) { ($0, $1) }
      .filter { self.page <= $0.0.totalPages }
      .map { [weak self] (movies, genres) -> [MovieViewData] in
        guard let strongSelf = self else { return [] }
        return strongSelf.mapMoviesGenresToMovieViewData(movies: movies, genres: genres)
      }.scan(dataSource.value) { (currentMovies, newMovies) -> [MovieViewData] in
        return currentMovies + newMovies
      }.do(onNext: { [weak self] _ in
        self?.isLoadingData.onNext(false)
        }, onError: { [weak self] _ in
          self?.isLoadingData.onNext(false)
          self?.errorMessage.onNext(MoviesViewModelConstants.requestFailed)
      })
  }
}

// MARK: Utility map methods
private extension MoviesViewModel {
  func mapMoviesGenresToMovieViewData(movies: Movies, genres: [Genre]) -> [MovieViewData] {
    return movies.results.map { [weak self] movie -> MovieViewData? in
      let movieGenres = movie.genreIds?.map { id -> Genre? in
        return genres.first(where: { $0.id == id })
        }.compactMap { $0 }
      
      return self?.mapMovieToMovieViewData(movie: movie,
                                           genres: movieGenres,
                                           language: movie.language)
      }.compactMap { $0 }
  }
  
  func mapMovieToMovieViewData(movie: Movie, genres: [Genre]?, language: String?) -> MovieViewData? {
    return MovieViewData(id: movie.id,
                         title: movie.title,
                         posterImagePath: movie.poster,
                         backdropImagePath: movie.backdrop,
                         ratingScore: movie.rating,
                         releaseYear: movie.releaseDate,
                         genres: genres,
                         revenue: movie.revenue,
                         description: movie.description,
                         runtime: movie.runtime,
                         language: language,
                         homepageLink: movie.homepage,
                         popularity: movie.popularity ?? 0)
  }
}
