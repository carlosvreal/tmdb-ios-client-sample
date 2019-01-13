//
//  MoviesServiceProvider.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

final class MoviesServiceProvider: ServiceProviderProtocol, MoviesServiceProtocol {
  let session: SessionHandler
  
  required init(session: SessionHandler = URLSession.shared) {
    self.session = session
  }
  
  func fetchMovieDetail(with identifier: String) -> Single<Movie> {
    let requestType = MoviesAPI.movie(id: identifier)
    return execute(requestType: requestType)
  }
  
  func fetchMovies(from page: Int) -> Single<Movies> {
    let requestType = MoviesAPI.movies(page: page)
    return execute(requestType: requestType)
  }
  
  func search(for query: String, page: Int) -> Single<Movies> {
    let requestType = MoviesAPI.search(query: query, page: page)
    return execute(requestType: requestType)
  }
  
  private func execute<T>(requestType: RequestableAPI) -> Single<T> where T: Decodable {
    return Single.create { [weak self] single in
      self?.session.executeRequest(with: requestType) { result in
        switch result {
        case .success(let data):
          do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            single(.success(decodedData))
          } catch {
            single(.error(ServiceError.invalidFormatData))
          }
        case .error(let error):
          single(.error(error))
        }
      }
      
      return Disposables.create()
    }
  }
  
  func genres() -> Single<[Genre]> {
    let requestType = MoviesAPI.genres
    
    return Single.create { [weak self] single in
      self?.session.executeRequest(with: requestType) { result in
        switch result {
        case .success(let data):
          do {
            let decodedData = try JSONDecoder().decode(Genres.self, from: data)
            single(.success(decodedData.genres))
          } catch {
            single(.error(ServiceError.invalidFormatData))
          }
        case .error(let error):
          single(.error(error))
        }
      }
      
      return Disposables.create()
    }
  }
}
