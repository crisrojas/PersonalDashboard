//
//  TogglListScreen.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 17/09/2022.
//

import SwiftUI

/*

 */
import CoreData
struct TogglListScreen: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @FetchRequest var items: FetchedResults<TogglProject>
  @AppStorage(.currentTogglUser) var currentTogglUser: Data?
  
  let currentUser: ApiTogglUser
  
  init(currentUser: ApiTogglUser) {
    self.currentUser = currentUser
    let predicate = NSPredicate(format: "user.id == %@", currentUser.id.description)
    
    self._items = FetchRequest(
      entity: TogglProject.entity(),
      sortDescriptors: [
        NSSortDescriptor(key: "isFavorite", ascending: false),
        NSSortDescriptor(key: "actualHours", ascending: false),
        NSSortDescriptor(key: "name", ascending: true),
      ],
      predicate: predicate,
      animation: .default
    )
  }
  
  var body: some View {
    
    VStack {
      
      Text("Disconnect")
        .onTap { currentTogglUser = nil}
        .alignX(.trailing)
        .top(.s4)
        .trailing(.s4)
      
      LazyVStack {
        ForEach(items) { project in
          TogglProjectRow(project: project)
          .alignX(.leading)
          .bottom(.s2)
        }
        .horizontal(.s16)
       
      }
      .scrollify()
      .listStyle(PlainListStyle())
      .task {
        do {
          try await load()
        } catch let error {
          if let error = error as? AppError {
            print(error)
          }
        }
      }
    }
  }

  
  func load() async throws {
    
    if
      let lastDate = TogglUser.getLastSyncDate(for: currentUser.id, in: viewContext) {
      let now = Date.now
      let syncInterval: TimeInterval = 1800 // 30 minutes
      let thresholdDate = lastDate.addingTimeInterval(syncInterval)
      
      /// If 30m have past since last sync,
      /// we should resync
      if now > thresholdDate {
        try await updateProjectsFromApi()
        return
      }
      
      /// User first loggin
    } else {
      try await updateProjectsFromApi()
    }
  }
  
  func updateProjectsFromApi() async throws {
    let projects = try await ApiProject.getProjects(with: currentUser.apiToken)
    try projects.forEach { try $0.saveLocally(in: viewContext, userId:  currentUser.id) }
    try TogglUser.setSyncTimestamp(for: currentUser.id, in: viewContext)
  }
}
