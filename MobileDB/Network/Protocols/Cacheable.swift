//
//  Cacheable.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/13/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

protocol Cacheable {
  associatedtype Object: Codable
  
  func add(data: Object, forKey: String)
  func object(forKey: String) -> Object?
}
