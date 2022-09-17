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

extension String {
  var toInt: Int? { Int(self) }
  var toInt32: Int32? { Int32(self) }
}

extension Bool {
  static func isLogged() -> Self {
    let apiToken = keychain.get(KeychainKey.togglApiToken.rawValue)
    return apiToken != nil
  }
}

extension Data {
  func decode<T: Codable>(to type: T.Type) throws -> T {
    return try jsonDecoder.decode(type, from: self)
  }
  
  func decode<T: Codable>(to type: T.Type) -> T? {
    do {
      return try jsonDecoder.decode(type, from: self)
    } catch {
      return nil
    }
  }
  
  var togglUser: ApiTogglUser? {
    do {
      return try jsonDecoder.decode(ApiTogglUser.self, from: self)
    } catch {
      return nil
    }
  }
}
