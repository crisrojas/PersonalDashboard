//
//  TogglAuthResponse.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation
import KeychainSwift
import CoreData

struct ApiTogglUser: Codable {
  let id: Int
  let apiToken: String
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case apiToken = "api_token"
  }
 
  /// Saves toggl user locally only if it doesn't exists
  func saveLocally(in viewContext: NSManagedObjectContext) throws {
  
   try viewContext.performAndWait {
      let item: TogglUser!
      let fetch: NSFetchRequest<TogglProject> = TogglProject.fetchRequest()
      fetch.predicate = NSPredicate(format: "id == %@", id.description)
      let results = try? viewContext.fetch(fetch)
      let noResults = results?.isEmpty ?? true

      if noResults {
        item = TogglUser(context: viewContext)
        item.id = Int32(id)
      }
      
      try viewContext.save()
    }

  }
}
