//
//  URLSessionExtension.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

extension URLSession: SessionHandler {
  func executeRequest(with requestType: RequestableAPI,
                      completion: @escaping SessionHandler.Completion) {
    guard let urlRequest = requestType.urlRequest else {
      assertionFailure("Invalid parameters request")
      return
    }
    
    if let key = urlRequest.url?.absoluteString,
      let dataAvailable = UserDefaults.standard.data(forKey: key) {
      return completion(.success(dataAvailable))
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
      
      if let key = urlRequest.url?.absoluteString,
        UserDefaults.standard.data(forKey: key) == nil {
        UserDefaults.standard.set(data, forKey: key)
      }
      
      completion(.success(data))
    }
    
    task.resume()
  }
}