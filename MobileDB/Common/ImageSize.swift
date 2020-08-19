//
//  ImageSize.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//

import UIKit

enum PosterSize: String {
  case w92
  case w154
  case w185
  case w342
  case w500
  case w780
  case original
}

struct PosterImage {
  static func bestSize() -> PosterSize {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
      if Device.isIPhone8PlusOrX {
        return .w500
      } else if Device.isIPhoneSE {
        return .w92
      }
      
      return .w342
    case .pad:
      return .w780
    default:
      return .original
    }
  }
}

enum BackdropSize: String {
  case w300
  case w780
  case w1280
  case original
}

struct BackdropImage {
  static func bestSize() -> BackdropSize {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
      if Device.isIPhone8PlusOrX {
        return .w1280
      }
      
      return .w780
    case .pad:
      return .w1280
    default:
      return .original
    }
  }
}
