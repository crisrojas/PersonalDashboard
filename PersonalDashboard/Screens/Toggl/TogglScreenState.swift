//
//  TogglViewModel.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation
import KeychainSwift

final class TogglScreenState: ObservableObject {
  
  @Published var phase: Phase = .idle
  
  enum Phase {
    case idle
    case loading
    case unlogged
    case logged
    case error
  }
}
