//
//  MovieDetailsViewModelTests.swift
//  MobileDBTests
//
//  Created by Carlos Real on 8/19/20.
//

import XCTest
import RxSwift
import RxTest
@testable import MobileDB

final class MovieDetailsViewModelTests: XCTestCase {
  private var viewModel: MovieDetailsViewModelType!
  private var movieData: MovieViewData!
  private var disposeBag: DisposeBag!
  private var mockService: MockConfigServiceProvider!
  private var scheduler: TestScheduler!
  
  override func setUp() {
    super.setUp()
    
    disposeBag = DisposeBag()
    scheduler = TestScheduler(initialClock: 0)
    movieData = StubData.movieData()
    mockService = MockConfigServiceProvider()
    
    viewModel = MovieDetailsViewModel(model: movieData, service: mockService)
  }
  
  func testProperties() {
    disposeBag.insert(
      viewModel.backdropImage.drive(onNext: { XCTAssertNil($0) }),
      viewModel.titleMovie.drive(onNext: { XCTAssertEqual($0, "Test") }),
      viewModel.screenTitle.drive(onNext: { XCTAssertEqual($0, "Test") }),
      viewModel.releaseYear.drive(onNext: { XCTAssertEqual($0, "2020") }),
      viewModel.runtime.drive(onNext: { XCTAssertEqual($0, "2h 0m") }),
      viewModel.language.drive(onNext: { XCTAssertTrue($0!.isEmpty) }),
      viewModel.descriptionMovie.drive(onNext: { XCTAssertEqual($0, "description") }),
      viewModel.genres.drive(onNext: { XCTAssertEqual($0, "Action | Adventure") }),
      viewModel.revenue.drive(onNext: { XCTAssertEqual($0!, "¤666.00")  }),
      viewModel.ratingScore.drive(onNext: { XCTAssertEqual($0, "4.4")  }),
      viewModel.homepage.drive(onNext: { XCTAssertEqual($0, "-")  })
    )
  }
  
  func testTapHomepageLink() {
    let tapObservable = scheduler.createHotObservable([Recorded.next(210, ())]).asObservable()
    viewModel
      .bindHomePage(to: tapObservable)
      .disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(Bool.self)
    viewModel
      .openHomePage
      .map { _ in true }
      .drive(observer)
      .disposed(by: disposeBag)
    
    scheduler.start()
    
    let expectedEvents = [Recorded.next(210, true)]
    XCTAssertEqual(expectedEvents, observer.events)
  }
}
