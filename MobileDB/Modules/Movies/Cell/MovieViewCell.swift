//
//  MovieViewCell.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

final class MovieViewCell: UITableViewCell {
  // MARK: - Properties
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var title: UILabel!
  @IBOutlet private weak var genres: UILabel!
  @IBOutlet private weak var releaseYear: UILabel!
  @IBOutlet private weak var popularity: UILabel!
  @IBOutlet private weak var loadingImage: UIActivityIndicatorView!
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Overriden functions
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  // MARK: - Public functions
  func setup(viewModel: MovieViewCellViewModel) {
    disposeBag.insert(
      viewModel.posterImage.drive(posterImageView.rx.image),
      viewModel.title.drive(title.rx.text),
      viewModel.genres.drive(genres.rx.text),
      viewModel.releaseYear.drive(releaseYear.rx.text),
      viewModel.popularity.drive(popularity.rx.text),
      viewModel.loadingImage.distinctUntilChanged().drive(loadingImage.rx.isAnimating)
    )
  }
}

// MARK: - ReusableIdentifier
extension MovieViewCell: ReusableIdentifier {}
