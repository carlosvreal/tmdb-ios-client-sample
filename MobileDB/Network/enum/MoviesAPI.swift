//
//  TMDBApi.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

struct ApiConstants {
  static let apiKey = "api_key"
  static let language = "language"
  static let page = "page"
  static let query = "query"
  static let includeAdult = "include_adult"
  static let enUSLanguage = "en-US"
}

/// TMDB API actions
enum MoviesAPI {
  case configuration
  case genres
  case movie(id: String)
  case movies(page: Int)
  case search(query: String, page: Int)
}

// MARK: - Extension RequestableAPI
extension MoviesAPI: RequestableAPI {
  var baseUrlPath: String {
    return "https://api.themoviedb.org/3/"
  }
  
  var path: String? {
    switch self {
    case .configuration: return "configuration"
    case .genres: return "genre/movie/list"
    case .movie(let id):
      guard !id.isEmpty else { return nil }
      return "movie/\(id)"
    case .movies: return "movie/popular"
    case .search: return "search/movie"
    }
  }
  
  var params: [String: Any]? {
    var defaultParam: [String: Any] {
      return [ApiConstants.apiKey: Settings.apiKey]
    }
    
    switch self {
    case .configuration:
      return defaultParam
    case .genres:
      var params = defaultParam
      params[ApiConstants.language] = ApiConstants.enUSLanguage
      
      return params
    case .movie(_):
      var params = defaultParam
      params[ApiConstants.language] = ApiConstants.enUSLanguage
      
      return params
    case .movies(let page):
      var params = defaultParam
      params[ApiConstants.language] = ApiConstants.enUSLanguage
      params[ApiConstants.page] = "\(page)"
      
      return params
    case .search(let query, let page):
      guard !query.isEmpty else { return nil }
      
      var params = defaultParam
      params[ApiConstants.language] = ApiConstants.enUSLanguage
      params[ApiConstants.page] = "\(page)"
      params[ApiConstants.query] = "\(query)"
      params[ApiConstants.includeAdult] = "false"
      
      return params
    }
  }
  
  var httpMethod: HttpMethod {
    return .get
  }
  
  var urlRequest: URLRequest? {
    guard let baseUrl = URL(string: baseUrlPath),
      let path = path,
      let params = params else { return nil }
    
    guard let encodedParams = params.formatToUrlParams().addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
      return nil
    }
    
    let url = baseUrl.appendingPathComponent(path, isDirectory: false)
      .appendingPathComponent(encodedParams)
    
    var urlRequest = URLRequest(url: url)
    urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
    urlRequest.timeoutInterval = 30
    urlRequest.httpMethod = httpMethod.description
    
    return urlRequest
  }
}

extension MoviesAPI: Equatable {
  static func == (lhs: MoviesAPI, rhs: MoviesAPI) -> Bool {
    switch (lhs, rhs) {
    case (.configuration, .configuration):
      return true
    case (.genres, .genres):
      return true
    case (.movie, .movie):
      return true
    case (.movies, .movies):
      return true
    case (.search, .search):
      return true
    default:
      return false
    }
  }
}
