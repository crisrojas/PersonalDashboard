//
//  ApiTogglProjecs.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation


/*
 
 Avaialble properties:
//    let workspaceID: Int
//    let clientID: String?
//    let isPrivate, active: Bool
//    let at, createdAt: Date
//    let serverDeletedAt: String?
//    let color: String
//    let billable, template, autoEstimates, estimatedHours: String?
//    let rate, rateLastUpdated, currency: String?
//    let recurring: Bool
//    let recurringParameters, currentPeriod, fixedFee: String?
//    let wid: Int
//    let cid: JSONNull?
 
 */

struct ApiProject: Identifiable, Decodable {
  let id: Int
    let name: String

  let active: Bool

  let actualHours: Int


    enum CodingKeys: String, CodingKey {
        case id
        case name
      case active
        case actualHours = "actual_hours"
    }
}
