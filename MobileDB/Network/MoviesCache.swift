//
//  MoviesCache.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/13/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct MoviesCache: Cacheable { 
  private static var repository = NSCache<NSString, NSData>()
  
  static func add(data: Data, key: String?) {
    guard let key = key else { return }
    let objectKey = NSString(string: key)
    
    MoviesCache.repository.setObject(data as NSData, forKey: objectKey)
  }
  
  static func object(forKey: String?) -> Data? {
    guard let key = forKey else { return nil }
    let objectKey = NSString(string: key)
    
    return MoviesCache.repository.object(forKey: objectKey) as Data?
  }
}
