//
//  MovieViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

final class MovieViewCellViewModel {
  let title = PublishSubject<String?>()
  let releaseYear = PublishSubject<String?>()
  let genres = PublishSubject<String?>()
  let posterImage = PublishSubject<UIImage?>()
  let popularity = PublishSubject<String?>()
  
  private var model: MovieViewModel?
  private let service: ConfigServiceProtocol
  
  init(service: ConfigServiceProtocol) {
    self.service = service
  }
  
  func setupData(with model: MovieViewModel) {
    self.model = model
    
    title.onNext(model.title)
    releaseYear.onNext(model.releaseYear)
    
    if let ratingScore = model.ratingScore {
      let rating = String(format: "%.1f", ratingScore)
      popularity.onNext(rating)
    }
    
    let genres = formatGenres(genres: model.genres)
    self.genres.onNext(genres)
  }
  
  func loadImage() {
    guard let model = model, let imagePath = model.imagePath else { return }

    _ = service
      .loadPoster(for: imagePath)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onSuccess: { [weak self] image in
        self?.posterImage.onNext(image)
      })
  }
  
  // MARK: Private methods
  
  private func formatGenres(genres: [Genre]?) -> String {
    guard let genres = genres else { return "" }
    
    return genres.reduce("", { (result, genre) in
      guard !result.isEmpty else {
        return result + genre.name.capitalized
      }
      
      return result + " | " + genre.name.capitalized
    })
  }
}
