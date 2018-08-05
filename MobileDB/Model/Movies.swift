//
//  Movies.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct Movies: Codable {
  enum CodingKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
  }
  
  let page: Int
  let results: [Movie]
  let totalPages: Int
}
