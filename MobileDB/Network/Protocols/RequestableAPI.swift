//
//  RequestableAPI.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible {
  case get
  
  var description: String {
    return rawValue.uppercased()
  }
}

protocol RequestableAPI {
  var baseUrlString: String { get }
  var path: String? { get }
  var httpMethod: HttpMethod { get }
  var params: [String: Any]? { get }
  var urlRequest: URLRequest? { get }
  var cacheEnabled: Bool { get }
}
