//
//  ServiceProviderProtocol.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

protocol ServiceProviderProtocol {
  var session: SessionHandler { get }
  
  init(session: SessionHandler)
}

protocol MoviesServiceProtocol {
  func fetchMovies(from page: Int) -> Single<Movies>
  func genres() -> Single<[Genre]>
  func search(for query: String, page: Int) -> Single<Movies>
  func fetchMovieDetail(with identifier: String) -> Single<Movie>
}

protocol ConfigServiceProtocol {
  func fetchConfig() -> Single<String>
  func loadBackdropImage(for path: String) -> Single<UIImage?>
  func loadPoster(for path: String) -> Single<UIImage?>
}
