//
//  TogglViewModel.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import Foundation
import KeychainSwift

/*
 @TODO
 - TogglView State is being reloadd
 - Clean keychain related logic
 */
final class TogglViewModel: ObservableObject {
    
  @Published var state: State = .idle
  @Published var email: String = ""
  @Published var password: String = ""
  
  private let keychain = KeychainSwift()
  
  enum State {
    case idle
    case unlogged
    case loading
    case loggedIn(ProjectResponse)
    case error
  }
  
  func load() {
    state = .loading
    
    guard let apiToken = keychain.get("1") else {
      state = .unlogged
      return
    }
   
    getProjects(apiToken: apiToken)
  }
  
  func login() {
    
    state = .loading
    
    var request = URLRequest(url: ApiRoutes.authentication.url!)
    
    request.httpMethod = "GET"
    
    let authData = (email + ":" + password).data(using: .utf8)!.base64EncodedString()
    
    request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
    
    
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      guard let self = self else { return }
      DispatchQueue.main.async {

        if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
          self.state = .error
          
        } else if let data = data {
          print(data)
          do {
            
            let response = try jsonDecoder.decode(TogglAuthResponse.self, from: data)
            
            self.keychain.set(response.apiToken, forKey: .togglApiToken)
            
            if self.keychain.set(response.apiToken, forKey: "1") {
              print("success when saving to keychain")
            } else {
              print("failure when saving to keychain")
            }
            
            if let apiToken = self.keychain.get("1") {
            
              self.getProjects(apiToken: apiToken)
            }
            
            // TODO: Cache Access Token in Keychain
          } catch {
            print("Unable to Decode Response \(error)")
            self.state = .error
          }
        }
        
      }
    }.resume()
  }
  
  func getProjects(apiToken: String) {
    
    state = .loading

    var request = URLRequest(url: ApiRoutes.projects.url!)

    request.httpMethod = "GET"

    let authData = (apiToken + ":" + "api_token").data(using: .utf8)!.base64EncodedString()

    request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")


    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      DispatchQueue.main.async { [self] in

        if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
          self?.state = .error

        } else if let data = data {
          print(data)
          do {
            let response = try jsonDecoder.decode(ProjectResponse.self, from: data).filter { apiProject in
              apiProject.active
            }
            
            self?.state = .loggedIn(response)
            print(response)
            

            // TODO: Cache Access Token in Keychain
          } catch {
            print("Unable to Decode Response \(error)")
            self?.state = .error
          }
        }
      }
    }.resume()
  }
}
