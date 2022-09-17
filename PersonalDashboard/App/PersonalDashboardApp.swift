//
//  PersonalDashboardApp.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 12/09/2022.
//

import SwiftUI

@main
struct PersonalDashboardApp: App {
  
  @AppStorage(.currentTogglUser) private var currentTogglUser: Data?
  @StateObject var appState = AppState()
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      SideBar()
        .environmentObject(appState)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .withHostingWindow { $0?.hidesTitleBar() }
//        .onAppear(perform: clearPersistence)
    }
  }
  
#if DEBUG
  private func clearPersistence() {
    keychain.clear()
    currentTogglUser = nil
    persistenceController.clearDatabase()
  }
#endif
}

extension UIWindow {
  func hidesTitleBar() {
#if targetEnvironment(macCatalyst)
    if let titlebar = window?.windowScene?.titlebar {
      titlebar.titleVisibility = .hidden
      titlebar.toolbar = nil
    }
    
#endif
  }
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

