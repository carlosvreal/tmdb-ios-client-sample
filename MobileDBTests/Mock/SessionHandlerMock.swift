//
//  SessionHandlerMock.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/05/18.
//

import Foundation
@testable import MobileDB

struct MockDataResponse {
  let response: Result
}

struct SessionHandlerMock: SessionHandler {
  var mockDataResponse: MockDataResponse!
  
  func executeRequest(with requestType: RequestableAPI, completion: @escaping Completion) {
    completion(mockDataResponse.response)
  }
}
