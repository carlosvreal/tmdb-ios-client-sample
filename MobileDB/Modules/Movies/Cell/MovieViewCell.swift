//
//  MovieViewCell.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

final class MovieViewCell: UITableViewCell, ReusableIdentifier {
  @IBOutlet private weak var posterImageView: UIImageView!
  @IBOutlet private weak var title: UILabel!
  @IBOutlet private weak var genres: UILabel!
  @IBOutlet private weak var releaseYear: UILabel!
  @IBOutlet private weak var popularity: UILabel!
  @IBOutlet private weak var loadingImage: UIActivityIndicatorView!
  
  let viewModel = MovieViewCellViewModel(service: ConfigServiceProvider())
  private var disposeBag: DisposeBag!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setupBind()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    posterImageView.image = nil
    title.text = nil
    genres.text = nil
    releaseYear.text = nil
    popularity.text = nil
    viewModel.willReuseCell()

    setupBind()
  }
  
  private func setupBind() {
    disposeBag = DisposeBag()
    
    viewModel.posterImage.observeOn(MainScheduler.asyncInstance)
      .bind(to: posterImageView.rx.image).disposed(by: disposeBag)
    viewModel.title.bind(to: title.rx.text).disposed(by: disposeBag)
    viewModel.genres.bind(to: genres.rx.text).disposed(by: disposeBag)
    viewModel.releaseYear.bind(to: releaseYear.rx.text).disposed(by: disposeBag)
    viewModel.popularity.bind(to: popularity.rx.text).disposed(by: disposeBag)
    viewModel.loadingImage.distinctUntilChanged()
      .bind(to: loadingImage.rx.isAnimating).disposed(by: disposeBag)
  }
}
