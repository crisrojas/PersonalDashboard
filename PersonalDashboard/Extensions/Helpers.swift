//
//  Helpers.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 15/09/2022.
//

import Foundation

extension Array {
  var isNotEmpty: Bool { !isEmpty }
}

extension String {
  var isNotEmpty: Bool { !isEmpty }
}

extension Bool {
  static func isLogged() -> Self {
    let apiToken = keychain.get(KeychainKey.togglApiToken.rawValue)
    return apiToken != nil
  }
}
