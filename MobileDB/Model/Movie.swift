//
//  Movie.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//

import Foundation

struct SpokenLanguage: Decodable {
  enum CodingKeys: String, CodingKey {
    case iso = "iso_639_1"
    case name
  }
  let iso: String
  let name: String
}

struct Movie: Decodable {
  let id: Int?
  let title: String?
  let posterPath: String?
  let backdropPath: String?
  let overview: String?
  let originalLanguage: String?
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
    case backdropPath = "backdrop_path"
    case posterPath = "poster_path"
    case overview
    case originalLanguage = "original_language"
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
