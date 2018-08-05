//
//  Genre.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct Genre: Codable {
  let id: Int
  let name: String
} 

struct Genres: Codable {
  let genres: [Genre]
}

extension Genre: Equatable {
  static func == (lhs: Genre, rhs: Genre) -> Bool {
    return lhs.id == rhs.id
  }
}
