//
//  RxBlockingExtension.swift
//  MobileDBTests
//
//  Created by Carlos Vinicius on 8/05/18.
//  Copyright © 2018 ArcTouch. All rights reserved.
//

import RxTest
import RxSwift
import RxBlocking

extension BlockingObservable {
  func firstOrNil() -> E? {
    do {
      return try first()
    } catch {
      return nil
    }
  }
  
  func toArrayOrNil() -> [E]? {
    do {
      return try toArray()
    } catch {
      return nil
    }
  }
  
  func error() -> Error? {
    do {
      _ = try self.first()
      return nil
    } catch {
      return error
    }
  }
  
  func error<T>() -> T? {
    do {
      _ = try self.first()
      return nil
    } catch {
      return error as? T
    }
  }
  
  func throwsError<T: Error>(_ error: T.Type) -> Bool {
    do {
      _ = try self.first()
      return false
    } catch _ as T {
      return true
    } catch {
      return false
    }
  }
}

extension TestableObserver {
  func eventElements() -> [ElementType] {
    return events.map { $0.value.element! }
  }
}
