//
//  MovieDetailsViewController.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/06/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift
import RxCocoa

final class MovieDetailsViewController: UIViewController, ReusableIdentifier {
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
  
  var viewModel: MovieDetailsViewModel?
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUIBind()
  }
  
  private func setupUIBind() {
    viewModel?.backdropImage.bind(to: backdropImageView.rx.image).disposed(by: disposeBag)
    viewModel?.titleMovie.bind(to: titleMovie.rx.text).disposed(by: disposeBag)
    viewModel?.releaseYear.bind(to: releaseYear.rx.text).disposed(by: disposeBag)
    viewModel?.runtime.bind(to: runtime.rx.text).disposed(by: disposeBag)
    viewModel?.language.bind(to: language.rx.text).disposed(by: disposeBag)
    viewModel?.descriptionMovie.bind(to: descriptionMovie.rx.text).disposed(by: disposeBag)
    viewModel?.genres.bind(to: genres.rx.text).disposed(by: disposeBag)
    viewModel?.revenue.bind(to: revenue.rx.text).disposed(by: disposeBag)
    viewModel?.ratingScore.bind(to: ratingScore.rx.text).disposed(by: disposeBag)
    viewModel?.homepage.map { !$0.isEmpty ? $0 : "-" }
      .bind(to: homepageButton.rx.title(for: .normal)).disposed(by: disposeBag)
    
    homepageButton.rx.tap.subscribe(onNext: { [weak self] in
      guard let linkUrl = self?.homepageButton.titleLabel?.text else { return }
      self?.openHomepage(with: linkUrl)
    }).disposed(by: disposeBag)
    viewModel?.setupData()
  }
  
  func openHomepage(with link: String) {
    guard let url = URL(string: link) else { return }
    
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
