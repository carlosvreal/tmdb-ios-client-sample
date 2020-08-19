//
//  Cacheable.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/13/18.
//

import Foundation

protocol Cacheable {
  associatedtype Object: Codable
  
  static func add(data: Object, key: String?)
  static func object(forKey: String?) -> Object?
}
