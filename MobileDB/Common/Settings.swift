//
//  Settings.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct Settings {
  static var baseImageUrl = "http://image.tmdb.org/t/p/"

  static var apiKey: String {
    guard let url = Bundle.main.url(forResource: "AppSettings", withExtension: "plist"),
      let data = try? Data(contentsOf: url),
      let appSettings = try? PropertyListDecoder().decode(AppSettings.self, from: data) else {
        preconditionFailure("AppSettings was not found.")
    }
    
    guard !appSettings.apiKey.isEmpty else {
      preconditionFailure("Api key is missing from AppSettings")
    }
    
    return appSettings.apiKey
  }
}
