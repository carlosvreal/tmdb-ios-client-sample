//
//  Settings.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

// Loads appKey tmdb from AppSettings.plist
private struct AppSettings: Codable {
  private enum CodingKeys: String, CodingKey {
    case apiKey = "api_key"
  }
  
  let apiKey: String
}

private struct DefaultConfig {
  static let baseImageUrlKey = "baseImageUrl"
  static let defaultImageURl = "http://image.tmdb.org/t/p/"
}

struct Settings {
  static var baseImageUrl: String {
    set {
      UserDefaults.standard.setValue(newValue, forKey: DefaultConfig.baseImageUrlKey)
    }
    get {
      let urlString = UserDefaults.standard.string(forKey: DefaultConfig.baseImageUrlKey)
      return urlString ?? DefaultConfig.defaultImageURl
    }
  }
  
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
