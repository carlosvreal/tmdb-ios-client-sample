//
//  AppDelegate.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 7/31/18.
//

import UIKit
import RxSwift
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  private let configService = ConfigServiceProvider()
  private let disposeBag = DisposeBag()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
    BGTaskScheduler
      .shared
      .register(forTaskWithIdentifier: BackgroundIdentiers.fetchConfig.rawValue,
                using: nil) { [weak self] task in
                  if let task = task as? BGAppRefreshTask {
                    self?.fetchConfig(task: task)
                  }
    }
    
    return true
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    scheduleFetchConfig()
  }
}

// MARK: - Background handlers
private extension AppDelegate {
  enum BackgroundIdentiers: String {
    case fetchConfig = "com.real.MobileDB.fetchConfig"
  }
  
  func fetchConfig(task: BGAppRefreshTask) {
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
    }
    
    configService
      .fetchConfig()
      .asObservable()
      .take(1)
      .asSingle()
      .do(onSuccess: { baseImageUrl in
        Settings.updateBaseImageURL(baseImageUrl)
      })
      .subscribe(onSuccess: { [weak self] baseImageUrl in
        self?.sendNotitication(with: baseImageUrl)
        
        task.setTaskCompleted(success: true)
        
        self?.scheduleFetchConfig()
      })
      .disposed(by: disposeBag)
  }
  
  func scheduleFetchConfig() {
    let fetchTask = BGProcessingTaskRequest(identifier: BackgroundIdentiers.fetchConfig.rawValue)
    fetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
    
    do {
      try BGTaskScheduler.shared.submit(fetchTask)
    } catch {
      print("Not able to submit task")
    }
  }
  
  func sendNotitication(with imageURL: String) {
    let userInfo: [String: Any] = [Strings.Notification.newConfigAvailble: imageURL]
    NotificationCenter.default.post(name: .fetchConfig,
                                    object: self,
                                    userInfo: userInfo)
  }
}
