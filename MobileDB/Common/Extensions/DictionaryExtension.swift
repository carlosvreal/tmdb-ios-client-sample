//
//  DictionaryExtension.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import Foundation

extension Dictionary {
  /// Format url params
  func formatToUrlParams() -> String {
    return self.reduce("?", { (result, item) in
      result + "&" + "\(item.key)=\(item.value)"
    })
  }
}
