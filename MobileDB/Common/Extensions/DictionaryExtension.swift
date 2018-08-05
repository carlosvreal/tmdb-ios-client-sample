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
    guard !self.isEmpty else { return "" }
    
    return self.reduce("?", { (result, item) in
      let newParam = "\(item.key)=\(item.value)"
      guard !result.isEmpty, result != "?" else {
        return result + newParam
      }
      
      return result + "&" + newParam
    })
  }
}
