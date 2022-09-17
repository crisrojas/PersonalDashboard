//
//  TogglSignInForm.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 15/09/2022.
//

import SwiftUI

/*
 @TODO:
 
- Save "ApiTogglUser" object into keychain
 */
struct TogglSignInFormView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @AppStorage(.currentTogglUser) private var currentUser: Data?
  @State var email = String()
  @State var password = String()
  @State var state: ViewState?

  enum ViewState {
    case loading
    case error(String)
  }

  var body: some View {
    
    switch state {
    case .loading: ProgressView()
    default: formView
    }
  }
  
  var formView: some View {
    Form {
      TextField("Email", text: $email)
      SecureField("Password", text: $password)
        .onSubmit(login)
      Text("Login")
        .onTap(perform: login)
        .overlay(errorView)
    }
  }
  
  @ViewBuilder
  var errorView: some View {
    if case let .error(message) = state {
      Text(message)
    } else {
      EmptyView()
    }
  }

  func login() {
    Task {
     
      state = .loading
      
      var request = URLRequest(url: ApiRoutes.authentication.url!)
      request.httpMethod = "GET"
      let authData = (email + ":" + password).data(using: .utf8)!.base64EncodedString()
      request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
      
      do {
        let (encodedUser, _ ) = try await URLSession.shared.data(for: request)
        let user = try jsonDecoder.decode(ApiTogglUser.self, from: encodedUser)
        try user.saveLocally(in: viewContext)
        currentUser = encodedUser
      } catch let error {
        state = .error(error.localizedDescription)
      }
    }
  }
}
