//
//  AppState.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 15/09/2022.
//
import Combine
import Foundation

final class AppState: ObservableObject {
  @Published var togglState = TogglScreenState()
  @Published var isLogged = Bool.isLogged()
}
