//
//  Movie.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct SpokenLanguage: Codable {
  enum CodingKeys: String, CodingKey {
    case iso = "iso_639_1"
    case name
  }
  let iso: String
  let name: String
}

struct Movie: Codable {
  let id: Int?
  let title: String?
  let poster: String?
  let backdrop: String?
  let description: String?
  let language: String?
  let popularity: Double?
  let releaseDate: String?
  let genreIds: [Int]?
  let genres: [Genre]?
  let runtime: Int?
  let rating: Double?
  let revenue: Int?
  let homepage: String?
  let spokenLanguage: [SpokenLanguage]?
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
    case genreIds = "genre_ids"
    case genres
    case revenue
    case runtime
    case homepage
    case rating = "vote_average"
    case spokenLanguage = "spoken_languages"
  }
}

extension Movie: Equatable {
  static func == (lhs: Movie, rhs: Movie) -> Bool {
    return lhs.id == rhs.id
  }
}
