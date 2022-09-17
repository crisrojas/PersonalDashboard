//
//  ConstantDependencies.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 15/09/2022.
//
import Foundation
import KeychainSwift


private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  return decoder
}()

let keychain: KeychainSwift = {
  return KeychainSwift()
}()

let jsonEncoder: JSONEncoder = {
  let encoder = JSONEncoder()
  // config
  return encoder
}()
