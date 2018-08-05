//
//  ConfigServiceProvider.swift
//  MobileDB
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxSwift

class ConfigServiceProvider: ServiceProviderProtocol, ConfigServiceProtocol {
  var session: SessionHandler
  
  required init(session: SessionHandler = URLSession.shared) {
    self.session = session
  }
}
