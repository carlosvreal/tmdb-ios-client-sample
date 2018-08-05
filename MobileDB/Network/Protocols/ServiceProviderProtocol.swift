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
  func fetchMovies(from page: Int) -> Single<[Movie]>
  func genres() -> Single<[Genre]>
  func search(for query: String, page: Int) -> Single<[Movie]>
}

protocol ConfigServiceProtocol {
  func fetchConfig() -> Completable
}
