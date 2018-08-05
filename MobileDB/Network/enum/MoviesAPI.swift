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
  static let defaultServiceURL = "https://api.themoviedb.org/3/"
}

/// TMDB API actions
enum MoviesAPI {
  case backdropImage(path: String)
  case configuration
  case genres
  case movie(id: String)
  case movies(page: Int)
  case posterImage(path: String)
  case search(query: String, page: Int)
}

// MARK: - Extension RequestableAPI
extension MoviesAPI: RequestableAPI {
  var baseUrlString: String {
    switch self {
    case .backdropImage, .posterImage:
      return Settings.baseImageUrl
    default:
      return ApiConstants.defaultServiceURL
    }
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
    case .backdropImage(let path):
      guard !path.isEmpty else { return nil }
      return "\(BackdropImage.bestSize().rawValue)\(path)"
    case .posterImage(let path):
      guard !path.isEmpty else { return nil }
      return "\(PosterImage.bestSize().rawValue)\(path)"
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
      params[ApiConstants.query] = "\(query)".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
      params[ApiConstants.includeAdult] = "false"
      
      return params
    case .backdropImage, .posterImage:
      return nil
    }
  }
  
  var httpMethod: HttpMethod {
    return .get
  }
  
  var urlRequest: URLRequest? {
    guard let path = path else { return nil }
    
    let basePath: String
    if let params = params {
      basePath = path + params.formatToUrlParams()
    } else {
      basePath = path
    }
    
    guard let url = URL(string: baseUrlString + basePath) else { return nil }
    var urlRequest = URLRequest(url: url)
    urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
    urlRequest.timeoutInterval = 30
    urlRequest.httpMethod = httpMethod.description
    
    return urlRequest
  }
}

// MARK: - Extension Equatable
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
    case (.backdropImage, .backdropImage):
      return true
    case (.posterImage, .posterImage):
      return true
    default:
      return false
    }
  }
}
