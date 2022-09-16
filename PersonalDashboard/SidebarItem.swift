//
//  SidebarItem.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 15/09/2022.
//

import Foundation
import SwiftUI

enum SidebarItem {
  case home
  case toggl
  
  var title: String {
    switch self {
    case .home: return "Home"
    case .toggl:return  "Toggl"
    }
  }
  
  var icon: some View {
    switch self {
    case .home:
      return Image(systemName: "house.fill").resizable()
        .size(18)
    case .toggl:
      return Image(systemName: "timer")
      .resizable()
      .size(18)
    }
  }
}

