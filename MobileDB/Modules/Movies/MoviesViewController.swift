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
  @IBOutlet weak var empyStateLabel: UILabel!
  
  private let disposeBag = DisposeBag()
  private let viewModel = MoviesViewModel()
  private let searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(MovieViewCell.self)
    setupSearchBar()
    setupOutletsBinds()
    
    viewModel.loadMoviesList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
  }
}

// MARK: - Extension Search Bar setup
private extension MoviesViewController {
  func setupSearchBar() {
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Movies"
    searchController.isActive = true
    navigationItem.searchController = searchController
    definesPresentationContext = true

    searchController.searchBar.rx.cancelButtonClicked
      .bind(to: viewModel.willCancelSearch).disposed(by: disposeBag)
    searchController.rx.didPresent
      .bind(to: viewModel.willCleanSearchResult).disposed(by: disposeBag)
    
    let searchQueryObservable = searchController.searchBar.rx.text.orEmpty
      .debounce(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
   
    searchQueryObservable
      .filter { !$0.isEmpty }
      .bind(to: viewModel.searchMovie).disposed(by: disposeBag)
    
    searchQueryObservable
      .filter { $0.isEmpty }
      .map { _ in }
      .bind(to: viewModel.willCleanSearchResult).disposed(by: disposeBag)

    searchController.searchBar.rx.cancelButtonClicked
      .bind(to: viewModel.willCancelSearch)
      .disposed(by: disposeBag)
  }
}

// MARK: - Setup table view bind and observables
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
      .map { [unowned self] (_, indexPath) -> Bool in
        let numberOfCells = 3
        return indexPath.item == self.tableView.numberOfRows(inSection: 0) - numberOfCells
      }
      .distinctUntilChanged()
      .filter { $0 == true }
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.nextPage.onNext(())
      }).disposed(by: disposeBag)
    
    tableView.rx.willDisplayCell.do(onNext: { (cell, _) in
      guard let cell = cell as? MovieViewCell else { return }
      cell.viewModel.willDisplayCell()
    }).subscribe()
      .disposed(by: disposeBag)
    
    // Loading indicator
    viewModel.isLoadingData.map { !$0 }
      .bind(to: loadingIndicator.rx.isHidden).disposed(by: disposeBag)
    viewModel.isLoadingData
      .bind(to: loadingIndicator.rx.isAnimating).disposed(by: disposeBag)
    
    // Refresh tap action
    refreshMovies.rx.tap.asDriver().drive(viewModel.refresh).disposed(by: disposeBag)
    
    // Present MovieDetail
    tableView.rx.modelSelected(MovieViewData.self)
      .subscribe(onNext: { [weak self] model in
        guard let id = model.id else { return }
        self?.viewModel.willSearchMovieDetail.onNext("\(id)")
      }).disposed(by: disposeBag)
    
    viewModel.didReceiveMovieDetail
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] model in
      self?.presentMovieDetail(with: model)
    }).disposed(by: disposeBag)
  }
  
  func presentMovieDetail(with model: MovieViewData) {
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
