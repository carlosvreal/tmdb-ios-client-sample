//
//  ReusableIdentifier.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//

import UIKit

protocol ReusableIdentifier: class { }

extension ReusableIdentifier where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

extension ReusableIdentifier where Self: UIViewController {
  static var identifier: String {
    return String(describing: self)
  }
}
