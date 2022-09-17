//
//  KeychainSwift.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import KeychainSwift

extension KeychainSwift {
  
  func set(_ value: String, forKey key: KeychainKey) {
    self.set(value, forKey: key.rawValue)
  }
  
  func get(_ key: KeychainKey) -> String? {
    return self.get(key.rawValue)
  }
  
  func delete(_ key: KeychainKey) {
    delete(key.rawValue)
  }
}

enum AppError: Error {
  case apiTokenNotFound
  case noCurrentUser
}

enum KeychainKey: String, CaseIterable {
  case tests = "test"
  case togglApiToken = "toggl_api_token"
  case currentTogglUser = "current_toggl_user"
  case currentTogglUserId = "current_toggl_user_id"
}
