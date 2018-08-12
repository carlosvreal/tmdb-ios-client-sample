//
//  MovieViewCellViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

final class MovieViewCellViewModel {
  let title = PublishSubject<String?>()
  let releaseYear = PublishSubject<String>()
  let genres = PublishSubject<String>()
  let posterImage = PublishSubject<UIImage>()
  let popularity = PublishSubject<String>()
  let loadingImage = BehaviorSubject(value: false)
  
  private var model: MovieViewData?
  private let service: ConfigServiceProtocol
  private var disposeBag = DisposeBag()
  
  init(service: ConfigServiceProtocol) {
    self.service = service
  }
  
  func willDisplayCell() {
    loadPosterImage()
  }
  
  func willReuseCell() {
    disposeBag = DisposeBag()
  }
  
  func setupData(with model: MovieViewData) {
    self.model = model
    
    title.onNext(model.title)
    
    if let releaseYear = model.releaseYear,
      let year = releaseYear.split(separator: "-").first {
      self.releaseYear.onNext(String(year))
    }
    
    if let ratingScore = model.ratingScore {
      let rating = String(format: "%.1f", ratingScore)
      popularity.onNext(rating)
    }
    
    if let genres = model.genres {
      self.genres.onNext(genres.formatGenresAsString())
    }
  }

  private func loadPosterImage() {
    guard let model = model, let imagePath = model.posterImagePath else { return }

    loadingImage.onNext(true)
    service.loadPoster(for: imagePath)
      .subscribe(onSuccess: { [unowned self] image in
        self.loadingImage.onNext(false)
        self.posterImage.onNext(image)
      }).disposed(by: disposeBag)
  }
}
