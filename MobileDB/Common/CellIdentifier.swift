//
//  CellIdentifier.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit

protocol CellIdentifier: class { }

extension CellIdentifier where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}
