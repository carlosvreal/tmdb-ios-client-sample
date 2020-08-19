//
//  DeviceSize.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//

import UIKit

struct ScreenSize {
  static let width = UIScreen.main.bounds.size.width
  static let heigth = UIScreen.main.bounds.size.height
  static let screenMaxLength  = max(ScreenSize.width, ScreenSize.heigth)
  static let screenMinLength  = min(ScreenSize.width, ScreenSize.heigth)
}

struct Device {
  static let isIPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
  static let isIPhone8  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
  static let isIPhone8PlusOrX  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength > 720.0
}
