//
//  AppDelegate.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 7/31/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private let configService = ConfigServiceProvider()
  private let disposeBag = DisposeBag()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    configService
      .fetchConfig()
      .asObservable()
      .take(1)
      .asSingle()
      .subscribe(onSuccess: { baseImageUrl in
        Settings.baseImageUrl = baseImageUrl
      })
      .disposed(by: disposeBag)
    
    return true
  }
}
