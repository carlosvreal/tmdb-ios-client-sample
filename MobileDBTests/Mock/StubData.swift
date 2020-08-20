//
//  MoviesStubData.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/05/18.
//

import Foundation
@testable import MobileDB

final class StubData {
  static var invalidData: Data {
    return "".data(using: .utf8)!
  }
  
  // MARK: Movies
  static func moviesData() -> Data {
    let bundle = Bundle(for: Self.self)
    let path = bundle.path(forResource: "movies_page_1", ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
  }
  
  static func stubMovies() -> Movies {
    let decoder = try! JSONDecoder().decode(Movies.self, from: StubData.moviesData())
    return decoder
  }
  
  static func movieData(id: Int = 1) -> MovieViewData {
    let genres = Array(StubData.stubGenres()[0...1])
    return MovieViewData(id: id,
                         title: "Test",
                         posterImagePath: nil,
                         backdropImagePath: nil,
                         ratingScore: 4.4,
                         releaseYear: "2020",
                         genres: genres,
                         revenue: 666,
                         description: "description",
                         runtime: 120,
                         language: "",
                         homepageLink: "",
                         popularity: 4)
  }
  
  // MARK: Genres
  static func genresData() -> Data {
    let bundle = Bundle(for: Self.self)
    let path = bundle.path(forResource: "genres", ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
  }
  
  static func stubGenres() -> [Genre] {
    let decoder = try! JSONDecoder().decode(Genres.self, from: StubData.genresData())
    return decoder.genres
  }
  
  // MARK: Configuration
  
  static func configData() -> Data {
    let bundle = Bundle(for: Self.self)
    let path = bundle.path(forResource: "configuration", ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
  }
}
