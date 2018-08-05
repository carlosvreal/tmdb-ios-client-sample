//
//  Movie.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct Movie: Codable {
  let id: Int?
  let title: String?
  let poster: String?
  let backdrop: String?
  let description: String?
  let language: String?
  let popularity: Double?
  let releaseDate: String?
  let genresId: [Int]?
  let genres: [Genre]?
  let duration: Int?
  let rating: Double?
  let revenue: Int?
  let homepage: String?
}

extension Movie {
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case backdrop = "backdrop_path"
    case poster = "poster_path"
    case description = "overview"
    case language = "original_language"
    case popularity
    case releaseDate = "release_date"
    case genresId = "genres_id"
    case genres
    case revenue
    case duration = "runtime"
    case homepage
    case rating = "vote_average"
  }
}

extension Movie: Equatable {
  static func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id
  }
}
