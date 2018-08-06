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
        
        cell.viewModel.loadImage()
      }).subscribe()
      .disposed(by: disposeBag)
  }
}
