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
  case invalidFormatData
  case invalidParameters(message: String)
  case unknown
  
  var message: String {
    switch self {
    case .requestFailed(_): return "Request Failed. Service unavailable"
    case .invalidFormatData: return "Invalid JSON format"
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
    case (.invalidFormatData, .invalidFormatData):
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
