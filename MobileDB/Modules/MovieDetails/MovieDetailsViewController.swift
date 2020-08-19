//
//  MovieDetailsViewController.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/06/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieDetailsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet private weak var backdropImageView: UIImageView!
  @IBOutlet private weak var titleMovie: UILabel!
  @IBOutlet private weak var releaseYear: UILabel!
  @IBOutlet private weak var runtime: UILabel!
  @IBOutlet private weak var language: UILabel!
  @IBOutlet private weak var ratingScore: UILabel!
  @IBOutlet private weak var descriptionMovie: UILabel!
  @IBOutlet private weak var genres: UILabel!
  @IBOutlet private weak var revenue: UILabel!
  @IBOutlet private weak var homepageButton: UIButton!
  @IBOutlet private weak var homepageLabel: UIView!
  
  private var viewModel: MovieDetailsViewModelType?
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.hidesBarsOnSwipe = false
    setupObservable()
  }
  
  func setup(viewModel: MovieDetailsViewModelType) {
    self.viewModel = viewModel
  }
}

// MARK: - Observable setup
private extension MovieDetailsViewController {
  func setupObservable() {
    guard let viewModel = viewModel else {
      assertionFailure("Missing view model")
      return
    }
    
    disposeBag.insert(
      viewModel.backdropImage.drive(backdropImageView.rx.image),
      viewModel.titleMovie.drive(titleMovie.rx.text),
      viewModel.titleMovie.compactMap { $0 }.drive(rx.title),
      viewModel.releaseYear.drive(releaseYear.rx.text),
      viewModel.runtime.drive(runtime.rx.text),
      viewModel.language.drive(language.rx.text),
      viewModel.descriptionMovie.drive(descriptionMovie.rx.text),
      viewModel.genres.drive(genres.rx.text),
      viewModel.revenue.drive(revenue.rx.text),
      viewModel.ratingScore.drive(ratingScore.rx.text),
      viewModel.homepage.compactMap { $0 }.map { !$0.isEmpty ? $0 : "-" }
        .drive(homepageButton.rx.title(for: .normal)),
      homepageButton.rx.tap.subscribe(onNext: { [weak self] in
        guard let linkUrl = self?.homepageButton.titleLabel?.text else { return }
        self?.openHomepage(with: linkUrl)
      })
    )
  }
  
  func openHomepage(with link: String) {
    guard let url = URL(string: link) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}

// MARK: - ReusableIdentifier
extension MovieDetailsViewController: ReusableIdentifier {}
