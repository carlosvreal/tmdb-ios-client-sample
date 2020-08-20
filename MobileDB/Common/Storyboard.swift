//
//  Storyboard.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/06/18.
//

import UIKit

enum Storyboard: String {
  case movies = "Movies"
  case movieDetails = "MovieDetails"
  
  var storyboard: UIStoryboard {
    UIStoryboard(name: rawValue, bundle: nil)
  }
  
  func viewController(_ identifier: String) -> UIViewController? {
    storyboard.instantiateViewController(withIdentifier: identifier)
  }
}
