//
//  SessionHandler.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

enum Result {
  case success(Data), error(ServiceError)
}

protocol SessionHandler {
  typealias Completion = (Result) -> Void
  
  func executeRequest(with requestType: RequestableAPI, completion: @escaping Completion)
}
