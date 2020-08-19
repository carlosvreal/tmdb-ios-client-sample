//
//  DictionaryExtension.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/04/18.
//

import Foundation

extension Dictionary {
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
