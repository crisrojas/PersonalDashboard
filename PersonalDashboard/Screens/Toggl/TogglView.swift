//
//  TogglView.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 13/09/2022.
//

import SwiftUI
import SwiftUItilities

/*
 @TODO
 - Add logout button
 - Add Errors
 - Add a synchronizer
 */
struct TogglView: View {
  
  @StateObject var viewModel = TogglViewModel()
  @State var barWidth = CGFloat.zero
  var body: some View {
    
    VStack {
        switch viewModel.state {
        case .unlogged:
     
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
            Button {
              viewModel.login()
            } label: {
              Text("Login")
            }
        case .idle:
          ProgressView()
          .onAppear(perform: viewModel.load)
        case .loading:
          ProgressView()
           
        case .loggedIn(let projects):
          List(projects.sorted(by: { $0.actualHours > $1.actualHours })) { project in
            
            let factor = Double(project.actualHours) / 365
            let width = barWidth * factor
            
            let finalWidth = width < barWidth ? width : barWidth
            
            let level = project.actualHours * 10 / 365
            
            VStack(alignment: .leading) {
              HStack {
               
                Text("\(project.actualHours)")
                .font(.caption)
                .width(40)
                Text(project.name)
               
              }
//              HStack {
//                Rectangle()
//                  .foregroundColor(.secondary)
//                  .frame(width: 24)
//                  .frame(height: 24)
//                  .cornerRadius(8)
//                  .overlay(
//                    Text("\(level)")
//                    .foregroundColor(.black)
//                  )
//
//                Rectangle()
//                  .frame(height: 16)
//                  .cornerRadius(8)
//                  .background(
//                    GeometryReader { geo in
//                      Color.clear.onAppear {
//                        barWidth = geo.size.width - 6
//                      }
//                    }
//                  )
//                .overlay(
//                  Rectangle()
//                    .frame(width: finalWidth)
//                  .foregroundColor(.green)
//                    .frame(height: 10)
//                  .cornerRadius(8)
//                  .padding(3), alignment: .leading
//                )
//
//                Text("\(project.actualHours)/365")
//
//              }
            }
            .padding(.bottom, 12)
          }
          .frame(maxWidth: 500)
        case .error:
          Text("Error")
          Button {
            viewModel.state = .unlogged
          } label: {
            Text("Retry")
          }
          
        }
    }
    .padding(.horizontal, 24)
  }
  
}
