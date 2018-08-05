//
//  ConfigServiceProvider.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

class ConfigServiceProvider: ServiceProviderProtocol, ConfigServiceProtocol {
  var session: SessionHandler
  
  required init(session: SessionHandler = URLSession.shared) {
    self.session = session
  }
  
  func fetchConfig() -> Completable {
    let requestType = MoviesAPI.configuration
    
    return Completable.create { [weak self] completable in
      self?.session.executeRequest(with: requestType) { result in
        switch result {
        case .success(let data):
          guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
            let value = json as? [String: Any],
            let images = value["images"] as? [String: Any],
            let imagesBaseUrl = images["secure_base_url"] as? String else {
              return completable(.error(ServiceError.invalidResponseData))
          }
          
          Settings.baseUrl = imagesBaseUrl
          
          completable(.completed)
        case .error(let error):
          completable(.error(error))
        }
      }
      
      return Disposables.create()
    }
  }
}
