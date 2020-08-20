//
//  MovieViewCellViewModel.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//

import RxSwift
import RxCocoa

protocol MovieViewCellViewModelType {
  var title: Driver<String?> { get }
  var releaseYear: Driver<String?> { get }
  var genres: Driver<String?> { get }
  var posterImage: Driver<UIImage?> { get }
  var popularity: Driver<String?> { get }
  var loadingImage: Driver<Bool> { get }
}

struct MovieViewCellViewModel {

  private var model: MovieViewData
  private let loadingImageSubject = PublishSubject<Bool>()
  private let service: ConfigServiceProtocol
  
  init(model: MovieViewData, service: ConfigServiceProtocol) {
    self.service = service
    self.model = model
  }
}
  
// MARK: - MovieViewCellViewModelType
extension MovieViewCellViewModel: MovieViewCellViewModelType {
  var title: Driver<String?> {
    .just(model.title)
  }
  
  var releaseYear: Driver<String?> {
    let year = model.releaseYear?.split(separator: "-").first ?? "-"
    return .just(String(year))
  }
  
  var genres: Driver<String?> {
    .just(model.genres?.formatGenresAsString())
  }
  
  var popularity: Driver<String?> {
    guard let ratingScore = model.ratingScore else {
      return .just(nil)
    }
    
    let rating = String(format: "%.1f", ratingScore)
    return .just(rating)
  }
  
  var loadingImage: Driver<Bool> {
    loadingImageSubject.asDriver(onErrorJustReturn: false)
  }
  
  var posterImage: Driver<UIImage?> {
    Observable.just(model.posterImagePath)
      .do(onNext: { _ in self.loadingImageSubject.onNext(true) })
      .compactMap { $0 }
      .flatMapLatest {
        self.service
          .loadPoster(for: $0)
          .catchError { _ in
            return .just(nil)
          }
      }
      .do(onNext: { _ in self.loadingImageSubject.onNext(false) })
      .asDriver(onErrorJustReturn: nil)
  }
}
