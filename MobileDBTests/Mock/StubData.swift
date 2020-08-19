//
//  MoviesStubData.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/05/18.
//

import Foundation
@testable import MobileDB

struct StubData {
  static var invalidData: Data {
    return "".data(using: .utf8)!
  }

  // MARK: Movies
  static func moviesData(bundle: Bundle) -> Data {
    let path = bundle.path(forResource: "movies_page_1", ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
  }
  
  static func stubMovies(data: Data) -> [Movie] {
    let encoded = try! JSONDecoder().decode(Movies.self, from: data)
    return encoded.results
  }
  
  // MARK: Genres
  static func genresData(bundle: Bundle) -> Data {
    let path = bundle.path(forResource: "genres", ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
  }
  
  static func stubGenres(data: Data) -> [Genre] {
    let encoded = try! JSONDecoder().decode(Genres.self, from: data)
    return encoded.genres
  }
  
  // MARK: Configuration
  
  static func configData(bundle: Bundle) -> Data {
    let path = bundle.path(forResource: "configuration", ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
  }
}
