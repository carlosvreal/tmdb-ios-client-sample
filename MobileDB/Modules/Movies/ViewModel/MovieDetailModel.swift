//
//  MovieDetailModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct MovieDetailModel {
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
}
