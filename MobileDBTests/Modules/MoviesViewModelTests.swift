//
//  MoviesViewModelTests.swift
//  MobileDBTests
//
//  Created by Carlos Real on 8/19/20.
//

import XCTest
import RxSwift
import RxTest
@testable import MobileDB

final class MoviesViewModelTests: XCTestCase {

  private var viewModel: MoviesViewModelType!
  private var disposeBag: DisposeBag!
  private var mockService: MockMoviesServiceProvider!
  private var scheduler: TestScheduler!
  
  override func setUp() {
    super.setUp()
    
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
    mockService = MockMoviesServiceProvider()
  
    viewModel = MoviesViewModel(service: mockService, scheduler: scheduler)
  }
  
  func testLoadDataSource() {
    let tapObservable = scheduler.createHotObservable([Recorded.next(210, ())]).asObservable()
    viewModel
      .bindLoadFirstPage(to: tapObservable)
      .disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(Bool.self)
    viewModel
      .dataSource
      .skip(1)
      .map { $0.isEmpty }
      .drive(observer)
      .disposed(by: disposeBag)
    
    let loadingObserver = scheduler.createObserver(Bool.self)
    viewModel
      .isLoadingData
      .drive(loadingObserver)
      .disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedEvents = [Recorded.next(210, true), .next(210, false)]
    XCTAssertEqual(expectedEvents, observer.events)
    
    let expectedEventsLoading = [Recorded.next(210, true), .next(210, false)]
    XCTAssertEqual(expectedEventsLoading, loadingObserver.events)
  }
  
  func testLoad_And_OpenMovieDetail() {
    let movieData = StubData.movieData()
    
    let tapObservable = scheduler.createHotObservable([Recorded.next(210, movieData)]).asObservable()
    viewModel
      .bindLoadMovieDetail(to: tapObservable)
      .disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(Bool.self)
    viewModel
      .movieDetail
      .map { _ in true }
      .drive(observer)
      .disposed(by: disposeBag)
    
    let loadingObserver = scheduler.createObserver(Bool.self)
    viewModel
      .isLoadingData
      .drive(loadingObserver)
      .disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedEvents = [Recorded.next(210, true)]
    XCTAssertEqual(expectedEvents, observer.events)
    
    let expectedEventsLoading = [Recorded.next(210, true), .next(210, false)]
    XCTAssertEqual(expectedEventsLoading, loadingObserver.events)
  }
  
  func testResetList() {
    let tapObservable1 = scheduler.createHotObservable([Recorded.next(210, ())]).asObservable()
    viewModel
      .bindLoadFirstPage(to: tapObservable1)
      .disposed(by: disposeBag)
    
    let tapObservable2 = scheduler.createHotObservable([Recorded.next(310, ())]).asObservable()
    viewModel
      .bindResetData(to: tapObservable2)
      .disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(Bool.self)
    viewModel
      .dataSource
      .skip(2)
      .map { $0.isEmpty }
      .drive(observer)
      .disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedEvents = [Recorded.next(210, false), .next(310, true)]
    XCTAssertEqual(expectedEvents, observer.events)
  }
  
  func testRefresh() {
    let tapObservable = scheduler.createHotObservable([Recorded.next(210, ())]).asObservable()
    viewModel
      .bindRefresh(to: tapObservable)
      .disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(Bool.self)
    viewModel
      .dataSource
      .skip(2)
      .map { $0.isEmpty }
      .drive(observer)
      .disposed(by: disposeBag)

    scheduler.start()
    
    let expectedEvents = [Recorded.next(210, false)]
    XCTAssertEqual(expectedEvents, observer.events)
  }
  
  func testSearchMovies() {
    let tapObservable = scheduler.createHotObservable([Recorded.next(210, "test")]).asObservable()
    viewModel
      .bindSearchMovies(to: tapObservable)
      .disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(Bool.self)
    viewModel
      .dataSource
      .skip(2)
      .map { $0.isEmpty }
      .drive(observer)
      .disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedEvents = [Recorded.next(210, false)]
    XCTAssertEqual(expectedEvents, observer.events)
  }
}
