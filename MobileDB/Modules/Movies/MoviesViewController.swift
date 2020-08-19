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
  
  // MARK: - Properties
  @IBOutlet private weak var tableView: UITableView! {
    didSet {
      tableView.register(MovieViewCell.self)
    }
  }
  @IBOutlet private weak var refreshMoviesButton: UIBarButtonItem!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet private weak var empyStateLabel: UILabel!
  
  private let disposeBag = DisposeBag()
  private let viewModel = MoviesViewModel()
  private let searchController = UISearchController(searchResultsController: nil)
  private let viewDidLoadSubject = PublishSubject<Void>()
  
  // MARK: - Overriden functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchBar()
    setupTableViewBinds()
    setupObservables()
    
    viewDidLoadSubject.onNext(())
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
    searchController.searchBar.placeholder = Strings.Home.searchTitle
    searchController.isActive = true
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
}

// MARK: - Setup tableview bind and observables
private extension MoviesViewController {
  func setupTableViewBinds() {
    viewModel
      .dataSource
      .asObservable()
      .bind(to:
        tableView.rx.items(cellIdentifier: MovieViewCell.identifier,
                           cellType: MovieViewCell.self)) {(_, movie, cell) in
                            let viewModel = MovieViewCellViewModel(model: movie,
                                                                   service: ConfigServiceProvider())
                            cell.setup(viewModel: viewModel)
      }
      .disposed(by: disposeBag)
    
    tableView.rx.willDisplayCell
      .map { [unowned self] (_, indexPath) -> Bool in
        let numberOfCells = 2
        return indexPath.item == self.tableView.numberOfRows(inSection: 0) - numberOfCells
      }
      .filter { $0 }
      .map { _ in }
      .bind(to: viewModel.bindLoadNextPage)
      .disposed(by: disposeBag)
    
    tableView
      .rx
      .modelSelected(MovieViewData.self)
      .asObservable()
      .bind(to: viewModel.bindLoadMovieDetail)
      .disposed(by: disposeBag)
  }
  
  func setupObservables() {
    let searchQueryObservable = searchController.searchBar.rx.text.orEmpty
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .share()
    
    let cancelSearch = searchController.searchBar.rx.cancelButtonClicked.asObservable()
    let refreshList = Observable.merge(cancelSearch, refreshMoviesButton.rx.tap.asObservable())
    
    disposeBag.insert(
      viewModel
        .bindLoadFirstPage(to: viewDidLoadSubject),
      viewModel
        .dataSource
        .map { !($0.count > 0) }
        .drive(tableView.rx.isHidden),
      viewModel
        .isLoadingData.map { !$0 }
        .drive(loadingIndicator.rx.isHidden),
      viewModel
        .isLoadingData
        .drive(loadingIndicator.rx.isAnimating),
      viewModel
        .bindRefresh(to: refreshList),
      viewModel
        .movieDetail
        .drive(onNext: { [weak self] model in
          self?.presentMovieDetail(with: model)
        }),
      viewModel
        .bindSearchMovies(to: searchQueryObservable.filter { !$0.isEmpty }),
      viewModel
        .bindRefresh(to: refreshList),
      viewModel
        .bindResetData(to: searchController.rx.didPresent.asObservable().skip(1))
    )
  }
}

// MARK: - Movie detail
private extension MoviesViewController {
  func presentMovieDetail(with model: MovieViewData) {
    let identifier = MovieDetailsViewController.identifier
    guard let viewController = Storyboard.movieDetail.viewController(identifier) as? MovieDetailsViewController else {
      assertionFailure("MoviesViewController ViewController not found")
      return
    }
    
    let viewModel = MovieDetailsViewModel(model: model)
    viewController.setup(viewModel: viewModel)
    
    navigationController?.pushViewController(viewController, animated: true)
  }
}
