//
//  MovieDetailsViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/06/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieDetailsViewModel {
  let backdropImage = PublishSubject<UIImage>()
  let titleMovie = BehaviorSubject<String>(value: "")
  let releaseYear = BehaviorSubject<String>(value: "")
  let runtime = BehaviorSubject<String>(value: "")
  let language = BehaviorSubject<String>(value: "")
  let ratingScore = BehaviorSubject<String>(value: "")
  let descriptionMovie = BehaviorSubject<String>(value: "")
  let genres = BehaviorSubject<String>(value: "")
  let revenue = BehaviorSubject<String>(value: "")
  let homepage = BehaviorSubject<String>(value: "")

  private let model: MovieViewData
  private let service: ConfigServiceProtocol
  private let disposeBag = DisposeBag()
  
  init(model: MovieViewData, service: ConfigServiceProtocol = ConfigServiceProvider()) {
    self.model = model
    self.service = service
  }

  func setupData() {
    if let title = model.title {
      titleMovie.onNext(title)
    }
    
    if let releaseYear = model.releaseYear,
      let year = releaseYear.split(separator: "-").first {
      self.releaseYear.onNext(String(year))
    }
    
    if let ratingScore = model.ratingScore {
      let ratingFormatted = String(format: "%.1f", ratingScore)
      self.ratingScore.onNext(ratingFormatted)
    }
    
    if let genres = model.genres {
      self.genres.onNext(genres.formatGenresAsString())
    }
    
    if let runtime = model.runtime {
      let formattedRuntime = formatTime(Double(runtime))
      self.runtime.onNext(formattedRuntime)
    }
    
    if let language = model.language {
      self.language.onNext(language)
    }
    
    if let description = model.description {
      self.descriptionMovie.onNext(description)
    }
    
    if let revenue = model.revenue,
      let formattedRevenue = formatToCurrency(revenue) {
      self.revenue.onNext(formattedRevenue)
    }
    
    if let homepage = model.homepageLink {
      self.homepage.onNext(homepage)
    }
    
    setupLoadBackdropImage()
  }
}

// MARK: Utility methods
private extension MovieDetailsViewModel {
  func setupLoadBackdropImage() {
    guard let backdrop = model.backdropImagePath else { return }
    _ = service
      .loadBackdropImage(for: backdrop)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onSuccess: { [weak self] image in
//        self?.backdropImage.onNext(image)
      })
  }
  
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
    
    guard let formattedValue = formatter.string(from: NSNumber(value: amount)) else {
      return nil
    }

    return formattedValue
  }
}
