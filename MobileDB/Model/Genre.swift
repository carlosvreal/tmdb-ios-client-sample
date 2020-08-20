//
//  Genre.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//

import Foundation

struct Genre: Decodable {
  let id: Int
  let name: String
} 

struct Genres: Decodable {
  let genres: [Genre]
}

extension Genre: Equatable {
  static func == (lhs: Genre, rhs: Genre) -> Bool {
    return lhs.id == rhs.id
  }
}
