//
//  TogglView.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//
import CoreData
import SwiftUI
import SwiftUItilities

/*
 @TODO
 - Add logout button
 - Add a synchronizer
 
 - Create a keychain property wrapper: https://medium.com/@ihamadfuad/swiftui-keychain-as-property-wrapper-ca60812e0e5e
 - Add to coredata model: shortTerm goal
 */
import Combine
import KeychainSwift
import SwiftWind


struct TogglScreen: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var state: TogglScreenState
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \TogglProject.name, ascending: true)],
    animation: .default)
  private var items: FetchedResults<TogglProject>
  
  
  @State var email = ""
  @State var password = ""
  
  var body: some View {
    VStack {
      switch state.phase {
      case .idle, .loading:
        ProgressView()
      case .unlogged:
        TogglSignInFormView(phase: $state.phase).horizontal(24)
      case .logged:
        loggedView()
      case .error:
        Text("Error")
        Text("Retry")
          .onTap { makePhase() }
      }
    }
    .onReceive(appState.$isLogged, perform: makePhase(from:))
    
  }
  
  func loggedView() -> some View {
   let projects = items
      .sorted(by: { $0.actualHours > $1.actualHours })
      .sorted(by: { $0.isFavorite && !$1.isFavorite })
    
   return List(projects) { project in
      TogglProjectRow(project: project)
       .horizontal(.s16)
    }
    .listStyle(PlainListStyle())
    .task {
      do {
        try await load()
      } catch is AppError {
        state.phase = .error
      } catch {
        state.phase = .error
      }
    }
  }
}

struct TogglProjectRow: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @State var hoverStar = false
  let project: TogglProject
  
  private var starColor: Color {
    project.isFavorite || hoverStar
    ? WindColor.yellow.c400
    : WindColor.zinc.c600
  }
  
  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: "star.fill")
      .resizable()
      .size(16)
      .foregroundColor(starColor)
      .onHover { hoverStar = $0 }
      .onTap(perform: toggleFavorite)
      
      Text(project.actualHours.description)
        .width(40)
        .multilineTextAlignment(.trailing)
        .foregroundColor(WindColor.cyan.c100)
      Text(project.name!)
    }
    .listRowSeparator(.hidden)
  }
  
  private func toggleFavorite() {
    project.isFavorite.toggle()
    do {
      try viewContext.save()
    } catch {
      // todo
    }
  }
}

// MARK: - Methods
extension TogglScreen {
  
  func makePhase(from bool: Bool = .isLogged()) {
    if bool {
      state.phase = .logged
    } else {
      state.phase =  .unlogged
    }
  }
  
  
  func load() async throws {
    
    if
      let lastDate = TogglUser.getCurrentUserLastSync(in: viewContext) {
      let now = Date.now
      let syncInterval: TimeInterval = 1800 // 30 minutes
      let thresholdDate = lastDate.addingTimeInterval(syncInterval)

      /// If 30m have past since last sync,
      /// we should resync
      if now > thresholdDate {
        try await saveProjectsLocally()
        return
      }
      
      /// User first loggin
    } else {
      try await saveProjectsLocally()
    }
  }
 
  func saveProjectsLocally() async throws {
    let projects = try await ApiProject.getProjects()
    if let currentUserId = TogglUser.getCurrentUserId(in: viewContext) {
      try projects.forEach { try $0.saveLocally(in: viewContext, userId:  currentUserId) }
      try TogglUser.saveCurrentUserSyncDate(in: viewContext)
    } else {
      /// ⚠️ if there's an apiToken, but not user in db,
      /// we're going to keep the user in this error forever...
      throw AppError.noCurrentUser
    }
  }
}





extension String {
  var toInt: Int? { Int(self) }
}
