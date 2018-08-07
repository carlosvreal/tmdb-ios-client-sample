//
//  ConfigServiceProviderTest.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

@testable import MobileDB
import XCTest
import RxTest
import RxSwift
import RxBlocking

class ConfigServiceProviderTest: XCTestCase {
  var session: SessionHandlerMock!
  var testScheduler: TestScheduler!
  
  override func setUp() {
    super.setUp()
    
    session = SessionHandlerMock()
    testScheduler = TestScheduler(initialClock: 0)
  }
  
  override func tearDown() {
    session = nil
    testScheduler = nil
    
    super.tearDown()
  }
  
  // MARK: Configuration
  
  func testValid_MovieList() {
    let bundleTest = Bundle(for: type(of: self))
    
    // given
    let configData = StubData.configData(bundle: bundleTest)
    let stubResponse = Result.success(configData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = ConfigServiceProvider(session: session)
    
    // when
    let observer = service.fetchConfig()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let base_url = observer.observeOn(MainScheduler.instance).toBlocking().firstOrNil()
    XCTAssertEqual(base_url, "https://image.tmdb.org/t/p/")
  }
  
  func testInvalidFormat_MovieList() {
    // given
    let configData = StubData.invalidData
    let stubResponse = Result.success(configData)
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = ConfigServiceProvider(session: session)
    
    // when
    let observer = service.fetchConfig()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, .invalidFormatData)
  }
  
  func testErrorRequestFormat_MovieList() {
    // given
    let stubResponse = Result.error(.requestFailed(nil))
    session.mockDataResponse = MockDataResponse(response: stubResponse)
    
    let service = ConfigServiceProvider(session: session)
    
    // when
    let observer = service.fetchConfig()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    
    // then
    let serviceError: ServiceError = observer.observeOn(MainScheduler.instance).toBlocking().error()!
    XCTAssertEqual(serviceError, .requestFailed(nil))
  }
}
