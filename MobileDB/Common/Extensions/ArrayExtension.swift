//
//  ArrayExtension.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/06/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

extension Array where Element == Genre {
  func formatGenresAsString() -> String {
    return self.reduce("", { (result, genre) in
      guard !result.isEmpty else {
        return result + genre.name.capitalized
      }
      
      return result + " | " + genre.name.capitalized
    })
  }
}
