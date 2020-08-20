//
//  MovieViewData.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//

import Foundation

// Model that represents data used by UI layer only
struct MovieViewData {
  let id: Int?
  let title: String?
  let posterImagePath: String?
  let backdropImagePath: String?
  let ratingScore: Double?
  let releaseYear: String?
  let genres: [Genre]?
  let revenue: Int?
  let description: String?
  let runtime: Int?
  let language: String?
  let homepageLink: String?
  let popularity: Double
}
