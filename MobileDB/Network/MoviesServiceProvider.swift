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
  
  func fetchMovies(from page: Int) -> Single<[Movie]> {
    let requestType = MoviesAPI.movies(page: page)
    
    return Single.create { [weak self] single in
      self?.session.executeRequest(with: requestType) { result in
        switch result {
        case .success(let data):
          do {
            let decodedData = try JSONDecoder().decode(Movies.self, from: data)
            single(.success(decodedData.results))
          } catch {
            single(.error(ServiceError.invalidResponseData))
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
            let decodedData = try JSONDecoder().decode([Genre].self, from: data)
            single(.success(decodedData))
          } catch {
            single(.error(ServiceError.invalidResponseData))
          }
        case .error(let error):
          single(.error(error))
        }
      }
      
      return Disposables.create()
    }
  }
  
  func search(for query: String, page: Int) -> Single<[Movie]> {
    let requestType = MoviesAPI.search(query: query, page: page)
    
    return Single.create { [weak self] single in
      self?.session.executeRequest(with: requestType) { result in
        switch result {
        case .success(let data):
          do {
            let decodedData = try JSONDecoder().decode(Movies.self, from: data)
            single(.success(decodedData.results))
          } catch {
            single(.error(ServiceError.invalidResponseData))
          }
        case .error(let error):
          single(.error(error))
        }
      }
      
      return Disposables.create()
    }
  }
}
