//
//  MockConfigServiceProvider.swift
//  MobileDBTests
//
//  Created by Carlos Real on 8/19/20.
//

import RxSwift
@testable import MobileDB

final class MockConfigServiceProvider: ConfigServiceProtocol {
  var shouldFail = false
  var baseImageUrl: String = ""
  var loadBackdropImage: UIImage? = nil
  var loadPoster: UIImage? = nil
  
  func fetchConfig() -> Single<String> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    return .just(baseImageUrl)
  }
  
  func loadBackdropImage(for path: String) -> Single<UIImage?> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    return .just(loadBackdropImage)
  }
  
  func loadPoster(for path: String) -> Single<UIImage?> {
    if shouldFail {
      return .error(RxError.noElements)
    }
    
    return .just(loadPoster)
  }
}
