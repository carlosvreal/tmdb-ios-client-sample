//
//  MoviesCache.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/13/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct MoviesCache: Cacheable {
  func add(data: Data, forKey: String) {
    UserDefaults.standard.set(data, forKey: forKey)
  }
  
  func object(forKey: String) -> Data? {
    return UserDefaults.standard.data(forKey: forKey)
  }
}
