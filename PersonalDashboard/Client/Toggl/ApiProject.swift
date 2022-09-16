//
//  ApiTogglProjecs.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation
import CoreData
import SwiftUI


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


extension ApiProject {
  
  /// Get toggl projects from API
  static func getProjects() async throws -> ProjectResponse {
    
    guard let apiToken = keychain.get(.togglApiToken) else {
      throw AppError.apiTokenNotFound
    }
    
    var request = URLRequest(url: ApiRoutes.projects.url!)
    request.httpMethod = "GET"
    
    let authData = (apiToken + ":" + "api_token").data(using: .utf8)!.base64EncodedString()
    
    request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try jsonDecoder.decode(ProjectResponse.self, from: data)
  }
  
  /// Saves project locally in CoreData.
  /// If it exists, update.
  /// If don't, insert.
  func saveLocally(in viewContext: NSManagedObjectContext, userId: Int) throws {
    
    let user = TogglUser.getUser(with: userId, in: viewContext)
    let item: TogglProject!
    
    let fetch: NSFetchRequest<TogglProject> = TogglProject.fetchRequest()
    fetch.predicate = NSPredicate(format: "id == %@", id.description)
    
    let results = try? viewContext.fetch(fetch)
    
    /// Update
    if let existingItem = results?.first {
      item = existingItem
      item.actualHours = Int32(actualHours)
      
    /// Insert
    } else {
      
      item = TogglProject(context: viewContext)
      item.user = user
      item.id = Int32(id)
      item.name = name
      item.actualHours = Int32(actualHours)
    }
    
    try viewContext.save()
  }
}
