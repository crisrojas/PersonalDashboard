//
//  ApiRoutes.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation

typealias ProjectResponse = [ApiProject]

enum ApiRoutes {
  case authentication
  case projects
  
  var path: String {
    switch self {
    case .authentication:
      return "https://api.track.toggl.com/api/v9/me"
    case .projects:
      return "https://api.track.toggl.com/api/v9/me/projects"
      
    }
  }
  
  var url: URL? {
    switch self {
    default: return URL(string: self.path)
    }
  }
}
