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

  let dataSource = Variable<[MovieViewData]>([])
  let refresh = PublishSubject<Void>()
  let nextPage = PublishSubject<Void>()
  let willSearchMovieDetail = PublishSubject<String>()
  let errorMessage = PublishSubject<String>()
  let isLoadingData = PublishSubject<Bool>()
  let didReceiveMovieDetail = PublishSubject<MovieViewData>()
  let searchMovie = PublishSubject<String>()
  let willCleanSearchResult = PublishSubject<Void>()
  let willCancelSearch = PublishSubject<Void>()
  let emptyStateMessage = PublishSubject<String>()
  
  private let page = Variable(0)
  private let service: MoviesServiceProtocol
  private let disposeBag: DisposeBag
  private let pagination = BehaviorSubject(value: 0)
  
  init(service: MoviesServiceProtocol = MoviesServiceProvider()) {
    self.service = service
    self.disposeBag = DisposeBag()
    
    setupServiceCalls()
    
    // Load first page
    nextPage.onNext(())
  }
}

// MARK: Setup observables
private extension MoviesViewModel {
  func setupServiceCalls() {
    // Refresh
    refresh
      .flatMap { [unowned self] page -> Observable<[MovieViewData]> in
        self.dataSource.value.removeAll()
        self.page.value = 1
        return self.loadMovies(from: self.page.value)
      }.bind(to: dataSource)
      .disposed(by: disposeBag)
    
    // Cancel search
    willCancelSearch.subscribe(onNext: { [unowned self] _ in
      self.refresh.onNext(())
    }).disposed(by: disposeBag)
    
    willCleanSearchResult.observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self] in
        self.dataSource.value.removeAll()
        self.page.value = 1
      }).disposed(by: disposeBag)

    // Load movie detail
    willSearchMovieDetail
      .flatMap { [unowned self] id -> Observable<MovieViewData> in
        return self.loadMovieDetail(with: id)
      }.bind(to: didReceiveMovieDetail)
      .disposed(by: disposeBag)
    
    // Pagination
    let paginator = nextPage
      .withLatestFrom(page.asObservable())
      .scan(page.value, accumulator: { (accumulated, _) -> Int in
        return accumulated + 1
      }).do(onNext: { [weak self] page in
        guard let strongSelf = self else { return }
        strongSelf.page.value = page
      })
    
    // fetch movies
    let moviesObservable = paginator
      .distinctUntilChanged()
      .flatMap { [weak self] page -> Observable<[MovieViewData]> in
        guard let strongSelf = self else { return .just([]) }
        return strongSelf.loadMovies(from: page)
    }
    
    //serach movies
    let serachObservable = Observable.combineLatest(searchMovie, paginator) { ($0, $1) }
      .skipWhile { $0.0.isEmpty }
      .flatMap { [weak self] (query, page) -> Observable<[MovieViewData]> in
        guard let strongSelf = self else { return .just([]) }
        return strongSelf.searchMovies(query: query, from: page)
      }
    
    moviesObservable.observeOn(MainScheduler.asyncInstance)
      .bind(to: dataSource).disposed(by: disposeBag)
    serachObservable.observeOn(MainScheduler.asyncInstance)
      .bind(to: dataSource).disposed(by: disposeBag)
  }
  
  func loadMovieDetail(with identifier: String) -> Observable<MovieViewData> {
    isLoadingData.onNext(true)
    return service.fetchMovieDetail(with: identifier).asObservable()
      .map { [weak self] movie -> MovieViewData? in
        return self?.mapMovieToMovieDetail(movie: movie,
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
  
  func loadMovies(from page: Int) -> Observable<[MovieViewData]> {
    isLoadingData.onNext(true)
    
    let fetchMovies = service.fetchMovies(from: page).asObservable()
    let genres = service.genres().asObservable()
    
    return loadMovies(fetchMovies, genres: genres)
  }
}

// MARK: Setup Search bind
private extension MoviesViewModel {
  func searchMovies(query: String, from page: Int) -> Observable<[MovieViewData]> {
    isLoadingData.onNext(true)
    
    let searchMovies = service.search(for: query, page: page).asObservable()
    let genres = service.genres().asObservable()
    
    return loadMovies(searchMovies, genres: genres)
  }
}

// MARK: Load movies
private extension MoviesViewModel {
  func loadMovies(_ movies: Observable<Movies>, genres: Observable<[Genre]>) -> Observable<[MovieViewData]> {

    isLoadingData.onNext(true)
    return Observable.zip(movies, genres) { ($0, $1) }
      .filter { self.page.value <= $0.0.totalPages }
      .map { [weak self] (movies, genres) -> [MovieViewData] in
        guard let strongSelf = self else { return [] }
        return strongSelf.mapMoviesGenresToMovieDetail(movies: movies, genres: genres)
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
  func mapMoviesGenresToMovieDetail(movies: Movies, genres: [Genre]) -> [MovieViewData] {
    return movies.results.map { [weak self] movie -> MovieViewData? in
      let movieGenres = movie.genreIds?.map { id -> Genre? in
        return genres.first(where: { $0.id == id })
        }.compactMap { $0 }
      
      return self?.mapMovieToMovieDetail(movie: movie,
                                         genres: movieGenres,
                                         language: movie.language)
      }.compactMap { $0 }
  }
  
  func mapMovieToMovieDetail(movie: Movie, genres: [Genre]?, language: String?) -> MovieViewData? {
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
                            homepageLink: movie.homepage)
  }
}
