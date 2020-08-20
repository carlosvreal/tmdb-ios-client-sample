//
//  MovieDetailsViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/06/18.
//

import RxSwift
import RxCocoa

protocol MovieDetailsViewModelType {
  var backdropImage: Driver<UIImage?> { get }
  var titleMovie: Driver<String?> { get }
  var screenTitle: Driver<String> { get }
  var releaseYear: Driver<String?> { get }
  var runtime: Driver<String?> { get }
  var language: Driver<String?> { get }
  var ratingScore: Driver<String?> { get }
  var descriptionMovie: Driver<String?> { get }
  var genres: Driver<String?> { get }
  var revenue: Driver<String?> { get }
  var homepage: Driver<String?> { get }
  var openHomePage: Driver<String> { get }
  
  func bindHomePage(to observable: Observable<Void>) -> Disposable
}

struct MovieDetailsViewModel {
  
  private let model: MovieViewData
  private let service: ConfigServiceProtocol
  private let disposeBag = DisposeBag()
  private let openHomePageSubject = PublishSubject<String>()
  
  init(model: MovieViewData, service: ConfigServiceProtocol = ConfigServiceProvider()) {
    self.model = model
    self.service = service
  }
}

// MARK: - MovieDetailsViewModelType
extension MovieDetailsViewModel: MovieDetailsViewModelType {
  var titleMovie: Driver<String?> {
    .just(model.title)
  }
  var screenTitle: Driver<String> {
    Observable.just(model.title)
      .compactMap { $0}
      .asDriver(onErrorJustReturn: "")
  }
  var releaseYear: Driver<String?> {
    let year = model.releaseYear?.split(separator: "-").first ?? "-"
    return .just(String(year))
  }
  var runtime: Driver<String?> {
    let runtime = model.runtime.map { formatTime(Double($0)) }
    return .just(runtime)
  }
  var language: Driver<String?> {
    .just(model.language)
  }
  var ratingScore: Driver<String?> {
    let ratingScore = model.ratingScore.map { String(format: "%.1f", $0) }
    return .just(ratingScore)
  }
  var genres: Driver<String?> {
    let genres = model.genres?.formatGenresAsString()
    return .just(genres)
  }
  var descriptionMovie: Driver<String?> {
    .just(model.description)
  }
  var revenue: Driver<String?> {
    let revenue = model.revenue.map(formatToCurrency)?.flatMap { $0 }
    return .just(revenue)
  }
  var homepage: Driver<String?> {
    let homepage = model.homepageLink.map { !$0.isEmpty ? $0 : "-" }
    return .just(homepage)
  }
  var backdropImage: Driver<UIImage?> {
    Observable.just(model.backdropImagePath)
      .compactMap { $0 }
      .flatMapLatest {
        self.service
          .loadBackdropImage(for: $0)
      }
      .asDriver(onErrorJustReturn: nil)
  }
  var openHomePage: Driver<String> {
    openHomePageSubject.asDriver(onErrorJustReturn: "")
  }
  
  func bindHomePage(to observable: Observable<Void>) -> Disposable {
    observable
      .compactMap { self.model.homepageLink }
      .bind(to: openHomePageSubject)
  }
}

// MARK: Utility methods
private extension MovieDetailsViewModel {
  func formatTime(_ movieRuntime: Double) -> String {
    guard movieRuntime > 60 else {
      return "\(Int(movieRuntime))m"
    }

    let totalHours = movieRuntime / 60
    let minutes = totalHours.truncatingRemainder(dividingBy: 1) * 60
    return "\(Int(totalHours))h \(Int(minutes))m"
  }
  
  func formatToCurrency(_ amount: Int) -> String? {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    
    guard let formattedValue = formatter.string(from: NSNumber(value: amount)) else { return nil }
    return formattedValue
  }
}
