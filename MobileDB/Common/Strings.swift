//
//  Strings.swift
//  MobileDB
//
//  Created by Carlos Real on 8/18/20.
//

import Foundation

extension String {
  var localized: String {
    NSLocalizedString(self, comment: "")
  }
}

struct Strings {
  struct Home {
    static let searchTitle = "Search Movies".localized
  }
  struct Error {
    static let messageEmptySearch = "No movies found".localized
    static let invalidMovieId = "Invalid Movie id".localized
    static let requestFailed = "Something went wrong. Please try again".localized
  }
  struct Notification {
    static let title = "Your configs were updated".localized
    static let body = "Check it out new movies!".localized
  }
}
