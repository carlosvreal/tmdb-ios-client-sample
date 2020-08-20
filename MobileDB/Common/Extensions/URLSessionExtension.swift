//
//  URLSessionExtension.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//

import Foundation

extension URLSession: SessionHandler {
  func executeRequest(with requestType: RequestableAPI,
                      completion: @escaping SessionHandler.Completion) {
    guard let urlRequest = requestType.urlRequest else {
      completion(.error(.invalidParameters(message: "Invalid parameters request")))
      assertionFailure("Invalid parameters request")
      return
    }
    
    if requestType.cacheEnabled {
      if let key = urlRequest.url?.absoluteString,
        let dataAvailable = MoviesCache.object(forKey: key) {
        return completion(.success(dataAvailable))
      }
    }
    
    let task = dataTask(with: urlRequest) { (data, _, error) in
      guard let data = data else {
        if let error = error {
          completion(.error(.requestFailed(error)))
          return
        }
        
        completion(.error(.unknown))
        return
      }
      
      guard !data.isEmpty else {
          completion(.error(.requestFailed(error)))
          return
      }
        
      if requestType.cacheEnabled {
        MoviesCache.add(data: data, key: urlRequest.url?.absoluteString)
      }
      
      completion(.success(data))
    }
    
    task.resume()
  }
}
