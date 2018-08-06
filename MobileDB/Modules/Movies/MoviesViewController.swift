//
//  MoviesViewController.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

final class MoviesViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var refreshMovies: UIBarButtonItem!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
  
  private let disposeBag = DisposeBag()
  private let viewModel = MoviesViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(MovieViewCell.self)
    
    setupOutletsBinds()
  }
}

private extension MoviesViewController {
  func setupOutletsBinds() {
    // TableView
    viewModel.moviesDataSource.asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: MovieViewCell.identifier,
                                   cellType: MovieViewCell.self)) {(_, movieViewModel, cell) in
        cell.viewModel.setupData(with: movieViewModel)
      }.disposed(by: disposeBag)
    
    viewModel.moviesDataSource.map { !($0.count > 0) }
      .drive(tableView.rx.isHidden).disposed(by: disposeBag)
    
    // Triggers next page
    tableView.rx.willDisplayCell
      .map { (_, indexPath) -> Bool in
        return indexPath.item == self.tableView.numberOfRows(inSection: 0) - 3
      }
      .distinctUntilChanged()
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.nextPage.onNext(())
      }).disposed(by: disposeBag)
    
    tableView.rx.willDisplayCell.do(onNext: { (cell, _) in
      guard let cell = cell as? MovieViewCell else { return }
      
      cell.viewModel.loadPosterImage()
    }).subscribe()
      .disposed(by: disposeBag)
    
    // Loading indicator
    viewModel.isLoadingData
      .bind(to: loadingIndicator.rx.isHidden).disposed(by: disposeBag)
    viewModel.isLoadingData
      .bind(to: loadingIndicator.rx.isAnimating).disposed(by: disposeBag)
    
    // Refresh tap action
    refreshMovies.rx.tap.asDriver().drive(viewModel.refresh).disposed(by: disposeBag)
    
    // Present MovieDetail
    tableView.rx.modelSelected(MovieDetailModel.self)
      .subscribe(onNext: { [weak self] model in
        guard let id = model.id else { return }
        self?.viewModel.loadMovieId.onNext("\(id)")
      }).disposed(by: disposeBag)
    
    viewModel.movieDetail
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] model in
      self?.presentMovieDetail(with: model)
    }).disposed(by: disposeBag)
  }
  
  func presentMovieDetail(with model: MovieDetailModel) {
    let identifier = MovieDetailsViewController.identifier
    guard let viewController = Storyboard.movieDetail.viewController(identifier) as? MovieDetailsViewController else {
      assertionFailure("MoviesViewController ViewController not found")
      return
    }
    
    let viewModel = MovieDetailsViewModel(model: model)
    viewController.viewModel = viewModel
    
    navigationController?.pushViewController(viewController, animated: true)
  }
}
