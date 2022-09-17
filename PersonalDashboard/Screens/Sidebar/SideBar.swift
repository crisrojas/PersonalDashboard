//
//  ContentView.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 12/09/2022.
//

import SwiftUI
import CoreData
import KeychainSwift
import SwiftWind

/*
 @ TODO:
 - Make home default view (list selection)
 - Use Composable Architecture?
 - Use Moya ?
 */

struct SideBar: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @State var selection: SidebarItem = .toggl
  @State var id: Int = 0
  var body: some View {
    NavigationView {
      List() {
        
        sidebarItem(.home) {
          HomeScreen()
        }
        
        sidebarItem(.toggl) {
          TogglScreen()
        }
      }
      .top(.s4)
      .environment(\.defaultMinListRowHeight, .s9)
      
      /// Temporary hack for showing the homeScreen on launch
      HomeScreen()
        .navigationBarHidden(true)
    }
    .background(Color.black)
  }
  
  func sidebarItem<Content: View>(_ item: SidebarItem, content: () -> Content) -> some View {
    
    HStack {
      item.icon
      
      Text(item.title)
        .font(.headline)
    }
    /// Temporal hack for hidden the navigation link
    /// default arrow inside lists
    .background(
      NavigationLink {
        content()
          .navigationTitle(item.title)
          .navigationBarHidden(true)
      } label: {
        EmptyView()
      }
    )
    .tag(item)
  }
}


extension String {
  static let currentTogglUser = "current_toggl_user"
}




struct PieProgress: View {
  
  @State var isHovering = false
  let progress: Double
  let color: WindColor

  var body: some View {
    Circle()
      .stroke(color.c400, lineWidth: 1)
      .overlay(
        PieShape(progress: progress)
          .padding(.s05)
          .foregroundColor(isHovering ? WindColor.cyan.c200 : color.c400)
      )
      .frame(maxWidth: .infinity)
      .aspectRatio(contentMode: .fit)
      .onHover { isHovering = $0 }
  }
}

struct PieShape: Shape {
  var progress: Double = 0.0
  private let startAngle: Double = (Double.pi) * 1.5
  private var endAngle: Double {
    get {
      return self.startAngle + Double.pi * 2 * self.progress
    }
  }
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let arcCenter =  CGPoint(x: rect.size.width / 2, y: rect.size.width / 2)
    let radius = rect.size.width / 2
    path.move(to: arcCenter)
    path.addArc(center: arcCenter, radius: radius, startAngle: Angle(radians: startAngle), endAngle: Angle(radians: endAngle), clockwise: false)
    path.closeSubpath()
    return path
  }
}
