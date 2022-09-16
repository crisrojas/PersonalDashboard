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
  
  @EnvironmentObject var appState: AppState
  @Environment(\.managedObjectContext) private var viewContext
  
  @State var email = String()
  @State var password = String()
  @Binding var phase: TogglScreenState.Phase
  
  var body: some View {
    TextField("Email", text: $email)
    SecureField("Password", text: $password)
      .onSubmit(login)
    Text("Login")
      .onTap(perform: login)
  }
  
  func login() {
    Task {
      phase = .loading
      
      var request = URLRequest(url: ApiRoutes.authentication.url!)
      request.httpMethod = "GET"
      let authData = (email + ":" + password).data(using: .utf8)!.base64EncodedString()
      request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
      
      do {
        let (data, _ ) = try await URLSession.shared.data(for: request)
        let user = try jsonDecoder.decode(ApiTogglUser.self, from: data)
        try user.saveLocally(in: viewContext)
        keychain.set(user.apiToken, forKey: .togglApiToken)
        keychain.set(user.id.description, forKey: .currentTogglUserId)
        
        appState.isLogged = true
        
      } catch {
        phase = .error
      }
    }
  }
}
