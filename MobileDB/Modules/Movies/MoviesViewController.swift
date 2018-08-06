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
  
  private let disposeBag = DisposeBag()
  private let viewModel = MoviesViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(MovieViewCell.self)
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
    setupOutletsBinds()
  }
  
  private func setupOutletsBinds() {
    viewModel.moviesDataSource.asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: MovieViewCell.identifier,
                                   cellType: MovieViewCell.self)) {(_, movieViewModel, cell) in
        cell.viewModel.setupData(with: movieViewModel)
      }.disposed(by: disposeBag)
    
    // Triggers next page
    tableView.rx.willDisplayCell
      .filter { (_, indexPath) -> Bool in
        return indexPath.item == self.tableView.numberOfRows(inSection: 0) - 3
      }.map { _ in }
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.nextPage()
      }).disposed(by: disposeBag)
  }
}

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? MovieViewCell else {
      preconditionFailure("Invalid cell type")
    }
    
    cell.viewModel.loadImage()
  }
}
