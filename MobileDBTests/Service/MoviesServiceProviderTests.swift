//
//  MoviesServiceProviderTests.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/05/18.
//

@testable import MobileDB
import XCTest
import RxTest
import RxSwift
import RxBlocking

class MoviesServiceProviderTests: XCTestCase {
  var session: SessionHandlerMock!
  var testScheduler: TestScheduler!
  
  override func setUp() {
    super.setUp()
    
    session = SessionHandlerMock()
    testScheduler = TestScheduler(initialClock: 0)
  }
  
  func testValid_MovieList() {
    // given
    let moviesData = StubData.moviesData()
    let stubResponse = Result.success(moviesData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.fetchMovies(from: 1)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let movies = observer.observeOn(MainScheduler.instance).toBlocking().firstOrNil()
    XCTAssertEqual(movies?.results, StubData.stubMovies().results)
  }
  
  func testInvalidFormat_MovieList() {
    // given
    let moviesData = StubData.invalidData
    let stubResponse = Result.success(moviesData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.fetchMovies(from: 1)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, ServiceError.invalidFormatData)
  }
  
  func testErrorRequestFormat_MovieList() {
    // given
    let stubResponse = Result.error(.requestFailed(nil))
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.fetchMovies(from: 1)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, .requestFailed(nil))
  }
  
  // MARK: Genre
  
  func testValid_GenresList() {
    // given
    let genresData = StubData.genresData()
    let stubResponse = Result.success(genresData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.genres()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let genres = observer.observeOn(MainScheduler.instance).toBlocking().firstOrNil()
    XCTAssertEqual(genres!, StubData.stubGenres())
  }
  
  func testInvalidFormat_GenreList() {
    // given
    let invalidData = StubData.invalidData
    let stubResponse = Result.success(invalidData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.genres()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, .invalidFormatData)
  }
  
  func testErrorRequestFormat_GenreList() {
    // given
    let stubResponse = Result.error(.requestFailed(nil))
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.genres()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, .requestFailed(nil))
  }
  
  // MARK: Search
  
  func testValid_SearchList() {
    // given
    let moviesData = StubData.moviesData()
    let stubResponse = Result.success(moviesData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.search(for: "test", page: 1)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let movies = observer.observeOn(MainScheduler.instance).toBlocking().firstOrNil()
    XCTAssertEqual(movies?.results, StubData.stubMovies().results)
  }
  
  func testInvalidFormat_SearchList() {
    // given
    let moviesData = StubData.invalidData
    let stubResponse = Result.success(moviesData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.search(for: "test", page: 1)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, ServiceError.invalidFormatData)
  }
  
  func testErrorRequestFormat_SearchList() {
    // given
    let stubResponse = Result.error(.requestFailed(nil))
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = MoviesServiceProvider(session: session)
    
    // when
    let observer = service.search(for: "test", page: 1)
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, .requestFailed(nil))
  }
}
