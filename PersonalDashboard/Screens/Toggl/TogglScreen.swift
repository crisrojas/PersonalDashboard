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
 - Add to coredata model: shortTerm goal
 */
import Combine
import KeychainSwift
import SwiftWind


struct TogglScreen: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @AppStorage(.currentTogglUser) var currentUser: Data?
  @State var error: String?
  @State var email = ""
  @State var password = ""
  
  var body: some View {
    if let currentUser = currentUser?.decode(to: ApiTogglUser.self) {
      TogglListScreen(currentUser: currentUser)
    } else {
      TogglSignInFormView().horizontal(24)
    }
  }
}
