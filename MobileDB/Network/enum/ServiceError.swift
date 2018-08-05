//
//  ServiceError.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

enum ServiceError: Error {
  case requestFailed(Error?)
  case invalidResponseData
  case invalidParameters(message: String)
  case unknown
  
  var message: String {
    switch self {
    case .requestFailed(_): return "Request Failed. Service unavailable"
    case .invalidResponseData: return "Invalid JSON format"
    case .invalidParameters(_): return "Invalid request params"
    case .unknown: return "Unknown error"
    }
  }
}

extension ServiceError: Equatable {
  static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
    switch (lhs, rhs) {
    case (.requestFailed, .requestFailed):
      return true
    case (.invalidResponseData, .invalidResponseData):
      return true
    case (.invalidParameters, .invalidParameters):
      return true
    case (.unknown, .unknown):
      return true
    default:
      return false
    }
  }
}
