//
//  PersonalDashboardApp.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 12/09/2022.
//

import SwiftUI

@main
struct PersonalDashboardApp: App {
  
  @StateObject var appState = AppState()
  
  let persistenceController = PersistenceController.shared
  
  init() {
    
  }
  
  var body: some Scene {
    WindowGroup {
      SideBar()
        .environmentObject(appState)
        .environmentObject(appState.togglState)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .withHostingWindow { window in
          #if targetEnvironment(macCatalyst)
            if let titlebar = window?.windowScene?.titlebar {
              titlebar.titleVisibility = .hidden
              titlebar.toolbar = nil
            }
          
          #endif
        }
              .onAppear(perform: clearPersistence)
    }
    //    .windowStyle(HiddenTitleBarWindowStyle())
  }
  
#if DEBUG
  private func clearPersistence() {
    keychain.clear()
//    persistenceController.clearDatabase()
  }
#endif
}

extension View {
  func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
    self.background(HostingWindowFinder(callback: callback))
  }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
  var callback: (UIWindow?) -> ()
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async { [weak view] in
      self.callback(view?.window)
    }
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
}

