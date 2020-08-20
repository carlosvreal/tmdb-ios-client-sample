//
//  MovieViewCellViewModelTests.swift
//  MobileDBTests
//
//  Created by Carlos Real on 8/19/20.
//

import XCTest
import RxSwift
import RxTest
@testable import MobileDB

final class MovieViewCellViewModelTests: XCTestCase {
  private var viewModel: MovieViewCellViewModelType!
  private var disposeBag: DisposeBag!
  private var mockService: MockConfigServiceProvider!
  private var movieData: MovieViewData!
  
  override func setUp() {
    super.setUp()
    disposeBag = DisposeBag()
    movieData = StubData.movieData()
    mockService = MockConfigServiceProvider()
    
    viewModel = MovieViewCellViewModel(model: movieData, service: mockService)
  }
  
  func testProperties() {
    disposeBag.insert(
      viewModel.posterImage.drive(onNext: { XCTAssertNil($0) }),
      viewModel.title.drive(onNext: { XCTAssertEqual($0, "Test") }),
      viewModel.genres.drive(onNext: { XCTAssertEqual($0!, "Action | Adventure") }),
      viewModel.releaseYear.drive(onNext: { XCTAssertEqual($0, "2020") }),
      viewModel.popularity.drive(onNext: { XCTAssertEqual($0, "4.4") }),
      viewModel.loadingImage.drive(onNext: { XCTAssertFalse($0) })
    )
  }
}
