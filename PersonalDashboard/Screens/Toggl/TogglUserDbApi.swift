//
//  TogglUser.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 16/09/2022.
//

import CoreData

extension TogglUser {
  
  static func setSyncTimestamp
  (for userId: Int, in viewContext: NSManagedObjectContext) throws {
    
    let user = getUser(with: userId, in: viewContext)
    user?.lastSync = Date.now
    try viewContext.save()
  }
  
  static func saveCurrentUserSyncDate(in viewContext: NSManagedObjectContext) throws {
    let currentUser = getCurrentUser(in: viewContext)
    currentUser?.lastSync = Date.now
    try viewContext.save()
  }
  
  static func getUserLastSync(id: Int, in viewContext: NSManagedObjectContext) throws -> Date? {
    let user = getUser(with: id, in: viewContext)
    return user?.lastSync
  }
  
  static func getCurrentUserId(in viewContext: NSManagedObjectContext) -> Int? {
    guard let int32 = TogglUser.getCurrentUser(in: viewContext)?.id else { return nil }
    return Int(int32)
  }
  
  static func getCurrentUser(in viewContext: NSManagedObjectContext) -> TogglUser? {
    guard
      let currentUserId = keychain.get(.currentTogglUserId)?.toInt
    else { return nil }
    
    return TogglUser.getUser(with: currentUserId, in: viewContext)
  }
  
  static func getCurrentUserLastSync(in viewContext: NSManagedObjectContext) -> Date? {
    guard
    let currentUserId = keychain.get(.currentTogglUserId)?.toInt
    else { return nil }
    
    return TogglUser.getLastSyncDate(for: currentUserId, in: viewContext)
  }

  
  static func getUser
  (with id: Int, in viewContext: NSManagedObjectContext) -> TogglUser? {
    
    let fetch = Self.fetchRequest()
    fetch.predicate = NSPredicate(format: "id == %@", id.description)
    
    do {
      let results = try viewContext.fetch(fetch)
      return results.first
      
    } catch {
      return nil
    }
  }
  
  static func getLastSyncDate
  (for userId: Int, in viewContext: NSManagedObjectContext) -> Date? {
    
    let currentUser = TogglUser.getUser(
      with: userId,
      in: viewContext
    )
    
    return currentUser?.lastSync
  }
}
