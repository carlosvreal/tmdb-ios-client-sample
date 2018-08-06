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
  let titleMovie = PublishSubject<String>()
  let releaseYear = PublishSubject<String>()
  let runtime = PublishSubject<String>()
  let language = PublishSubject<String>()
  let ratingScore = PublishSubject<String>()
  let descriptionMovie = PublishSubject<String>()
  let genres = PublishSubject<String>()
  let revenue = PublishSubject<String>()

  private let model: MovieDetailModel
  private let service: ConfigServiceProtocol
  private let disposeBag = DisposeBag()
  
  init(model: MovieDetailModel, service: ConfigServiceProtocol = ConfigServiceProvider()) {
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
        self?.backdropImage.onNext(image)
      })
  }
  
  func formatTime(_ time: Double) -> String {
    guard time > 3600 else {
      return "\(Int(time / 60))m"
    }
    
    let totalHours = time / 3600
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
