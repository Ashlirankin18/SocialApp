//
//  UserSession.swift
//  SicialApp
//
//  Created by Ashli Rankin on 1/2/19.
//  Copyright © 2019 Ashli Rankin. All rights reserved.
//

import Foundation

final class UserSession {
  private init() {}
  
  private static var user: User!
  static func setUser(user: User) {
    self.user = user
  }
  
  static func getUser() -> User? {
    guard let user = user else { return nil }
    return user
  }
}
