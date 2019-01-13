//
//  AppDelegate.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 7/31/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private let configService = ConfigServiceProvider()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    setupConfig()
    return true
  }
  
  private func setupConfig() {
    _ = configService.fetchConfig()
      .asObservable().take(1).asSingle()
      .subscribe(onSuccess: { baseImageUrl in
        Settings.baseImageUrl = baseImageUrl
      })
  }
}
