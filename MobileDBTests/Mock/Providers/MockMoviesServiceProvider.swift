//
//  MockMoviesServiceProvider.swift
//  MobileDBTests
//
//  Created by Carlos Real on 8/19/20.
//

import Foundation
import RxSwift
@testable import MobileDB

final class MockMoviesServiceProvider: MoviesServiceProtocol {
  var shouldFail = false
  var movieList: [Movie] = StubData.stubMovies().results
  var genreList: [Genre] = []
  var movieDetail: Movie = StubData.stubMovies().results.first!
  
  func fetchMovies(from page: Int) -> Single<Movies> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    let movies = Movies(page: 0, results: movieList, totalPages: 1)
    return .just(movies)
  }
  
  func genres() -> Single<[Genre]> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    return .just(genreList)
  }
  
  func search(for query: String, page: Int) -> Single<Movies> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    let movies = Movies(page: 0, results: movieList, totalPages: 1)
    return .just(movies)
  }
  
  func fetchMovieDetail(with identifier: String) -> Single<Movie> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    return .just(movieDetail)
  }
}
