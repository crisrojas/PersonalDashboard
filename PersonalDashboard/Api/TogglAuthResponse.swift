//
//  TogglAuthResponse.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation

struct TogglAuthResponse: Codable {
  let apiToken: String

    enum CodingKeys: String, CodingKey {
        case apiToken = "api_token"
    }
}
