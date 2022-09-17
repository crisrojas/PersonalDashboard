//
//  HomeScreen.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 17/09/2022.
//

import SwiftUI

struct HomeScreen: View {
  
  @AppStorage(.currentTogglUser) var currentTogglUser: Data?
  
  var body: some View {
    
    if let currentUser = currentTogglUser?.decode(to: ApiTogglUser.self) {
      HomeTogglList(userId: currentUser.id)
    } else {
      Text("Not logged")
    }
  }
}
