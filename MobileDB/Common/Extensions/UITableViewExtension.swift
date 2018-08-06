//
//  UITableViewExtension.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit

extension UITableView {
  func register<T: UITableViewCell>(_: T.Type) where T: CellIdentifier {
    let nib = UINib(nibName: T.identifier, bundle: nil)
    register(nib, forCellReuseIdentifier: T.identifier)
  }
}
