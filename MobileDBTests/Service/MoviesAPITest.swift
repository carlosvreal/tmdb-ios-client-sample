//
//  MoviesAPITest.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import XCTest
@testable import MobileDB

class MoviesAPITest: XCTestCase {
  
  // MARK: Configuration
  
  func testMovieAPI_Configuration() {
    XCTAssertEqual(MoviesAPI.configuration, MoviesAPI.configuration)
  }
  
  func testValidUrlRequest_Configuration() {
    let urlRequest = MoviesAPI.configuration.urlRequest
    
    XCTAssertNotNil(urlRequest)
  }
  
  func testNotEmptyParams_Configuration() {
    let params = MoviesAPI.configuration.params
    
    XCTAssertFalse(params!.isEmpty)
  }
  
  func testValidAPIKeyParam_Configuration() {
    let params = MoviesAPI.configuration.params!
    let apiKey = params[ApiConstants.apiKey] as? String
    
    XCTAssertNotNil(apiKey)
    XCTAssertFalse(apiKey!.isEmpty)
  }
  
  // MARK: Genres
  
  func testMovieAPI_Genres() {
    XCTAssertEqual(MoviesAPI.genres, MoviesAPI.genres)
  }
  
  func testValidUrlRequest_Genres() {
    let urlRequest = MoviesAPI.genres.urlRequest
    
    XCTAssertNotNil(urlRequest)
  }
  
  func testNotEmptyParams_Genres() {
    let params = MoviesAPI.genres.params
    
    XCTAssertFalse(params!.isEmpty)
  }
  
  func testValidAPIKeyParam_Genres() {
    let params = MoviesAPI.genres.params!
    let apiKey = params[ApiConstants.apiKey] as? String
    
    XCTAssertNotNil(apiKey)
    XCTAssertFalse(apiKey!.isEmpty)
  }
  
  func testValidApiKeyParam_Genres() {
    let params = MoviesAPI.genres.params!
    let apiKey = params[ApiConstants.apiKey] as? String
    
    XCTAssertNotNil(apiKey)
    XCTAssertFalse(apiKey!.isEmpty)
  }
  
  func testValidLanguageParam_Genres() {
    let params = MoviesAPI.genres.params!
    let language = params[ApiConstants.language] as? String
    
    XCTAssertNotNil(language)
    XCTAssertFalse(language!.isEmpty)
  }
  
  // MARK: MovieDetail
  
  func testMovieAPI_MovieDetail() {
    XCTAssertEqual(MoviesAPI.movie(id: ""), MoviesAPI.movie(id: ""))
  }
  
  func testValidUrlRequest_MovieDetail() {
    let urlRequest = MoviesAPI.movie(id: "297761").urlRequest
    
    XCTAssertNotNil(urlRequest)
  }
  
  func testInvalidUrlRequest_MovieDetail() {
    XCTAssertNil(MoviesAPI.movie(id: "").urlRequest)
  }
  
  func testValidParams_MovieDetail() {
    let params = MoviesAPI.movie(id: "297761").params
    
    XCTAssertFalse(params!.isEmpty)
  }
  
  func testValidAPIKeyParam_MovieDetail() {
    let params = MoviesAPI.movie(id: "297761").params!
    let apiKey = params[ApiConstants.apiKey] as? String
    
    XCTAssertNotNil(apiKey)
    XCTAssertFalse(apiKey!.isEmpty)
  }
  
  func testValidLanguageParam_MovieDetail() {
    let params = MoviesAPI.movie(id: "1").params!
    let language = params[ApiConstants.language] as? String
    
    XCTAssertNotNil(language)
    XCTAssertFalse(language!.isEmpty)
  }
  
  // MARK: Movies
  
  func testMovieAPI_Movies() {
    XCTAssertEqual(MoviesAPI.movies(page: 0), MoviesAPI.movies(page: 0))
  }
  
  func testValidUrlRequest_Movies() {
    let urlRequest = MoviesAPI.movies(page: 1).urlRequest
    
    XCTAssertNotNil(urlRequest)
  }
  
   func testValidParams_Movies() {
    let params = MoviesAPI.movies(page: 1).params
    
    XCTAssertFalse(params!.isEmpty)
  }
  
  func testValidAPIKeyParam_Movies() {
    let params = MoviesAPI.movies(page: 1).params!
    let apiKey = params[ApiConstants.apiKey] as? String
    
    XCTAssertNotNil(apiKey)
    XCTAssertFalse(apiKey!.isEmpty)
  }
  
  func testValidLanguageParam_Movies() {
    let params = MoviesAPI.movies(page: 1).params!
    let language = params[ApiConstants.language] as? String
    
    XCTAssertNotNil(language)
    XCTAssertFalse(language!.isEmpty)
  }
  
  func testValidPageParam_Movies() {
    let params = MoviesAPI.movies(page: 1).params!
    let page = params[ApiConstants.page] as? String
    
    XCTAssertNotNil(page)
    XCTAssertFalse(page!.isEmpty)
  }

  // MARK: Search
  
  func testMovieAPI_Search() {
    XCTAssertEqual(MoviesAPI.search(query: "", page: 0), MoviesAPI.search(query: "", page: 0))
  }
  
  func testValidUrlRequest_Search() {
    let urlRequest = MoviesAPI.search(query: "Suicide Squad", page: 1).urlRequest
    
    XCTAssertNotNil(urlRequest)
  }
  
  func testValidAPIKeyParam_Search() {
    let params = MoviesAPI.search(query: "Suicide Squad", page: 1).params!
    let apiKey = params[ApiConstants.apiKey] as? String
    
    XCTAssertNotNil(apiKey)
    XCTAssertFalse(apiKey!.isEmpty)
  }
  
  func testValidLanguageParam_Search() {
    let params = MoviesAPI.search(query: "1", page: 1).params!
    let language = params[ApiConstants.language] as? String
    
    XCTAssertNotNil(language)
    XCTAssertFalse(language!.isEmpty)
  }
  
  func testValidQueryParam_Search() {
    let params = MoviesAPI.search(query: "1", page: 1).params!
    let query = params[ApiConstants.query] as? String
    
    XCTAssertNotNil(query)
    XCTAssertFalse(query!.isEmpty)
  }
  
  // MARK: Backdrop
  
  func testMovieAPI_Backdrop() {
    XCTAssertEqual(MoviesAPI.backdropImage(path: ""), MoviesAPI.backdropImage(path: ""))
  }
  
  func testValidUrlRequest_Backdrop() {
    XCTAssertNotNil(MoviesAPI.backdropImage(path: "/ndlQ2Cuc3cjTL7lTynw6I4boP4S.jpg").urlRequest)
  }
  
  // MARK: Poster
  
  func testMovieAPI_Poster() {
    XCTAssertEqual(MoviesAPI.posterImage(path: ""), MoviesAPI.posterImage(path: ""))
  }
  
  func testValidUrlRequest_Poster() {
    XCTAssertNotNil(MoviesAPI.posterImage(path: "/e1mjopzAS2KNsvpbpahQ1a6SkSn.jpg").urlRequest)
  }
}
