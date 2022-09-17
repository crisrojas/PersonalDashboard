//
//  HomeTogglList.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 17/09/2022.
//

import SwiftUI
import SwiftWind

struct HomeTogglList: View {
 
  @FetchRequest var items: FetchedResults<TogglProject>
  @State var longTerm = false
  let userId: Int
  
  
  init(userId: Int) {
    self.userId = userId
    let predicate = NSPredicate(format: "user.id == %i && isFavorite = %d", userId, true)
    
    self._items = FetchRequest(
      entity: TogglProject.entity(),
      sortDescriptors: [NSSortDescriptor(key: "actualHours", ascending: false)],
      predicate: predicate
    )
  }
  
  var body: some View {
    
        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: .s3) {
            Image(systemName: "timer")
              .resizable()
              .size(.s6)
              .foregroundColor(WindColor.red.c400)
    
    
            Text("Toggl")
              .font(.title)
              .fontWeight(.bold)
    
            Spacer()
          }
          .top(.s16)
          .bottom(.s12)
          
          Text(longTerm ? "Long term" : "Short term")
            .bottom(.s3)
            .alignX(.trailing)
            .onTap {
              longTerm.toggle()
            }
           
    
          LazyVStack(alignment: .leading) {
            ForEach(items) { project in
              
              if longTerm {
                
                HomeTogglListRow(name: project.name!, progress: project.longTermProgress)
                  .bottom(.s2)
                
              } else {
                
                if let shortTermProgress = project.shortTermProgress {
                  
                  
                  HomeTogglListRow(name: project.name!, progress: shortTermProgress)
                    .bottom(.s2)
                }
              }
            }
          }
          .listStyle(.plain)
         
    
          Spacer()
        }
        .horizontal(.s16)
  }
}


struct HomeTogglListRow: View {
  @State private var expanded: Bool = false
  let name: String
  let progress: Double
  
  var body: some View {
    VStack {
      HStack(spacing: .s3) {
        PieProgress(progress: progress, color: .zinc)
          .size(.s4)
        Text(name)
        
        Spacer()
      }
    }
    .onTapGesture {
      expanded.toggle()
    }
  }
}


extension TogglProject {
  
  var longTermProgress: Double {
    let goal = longTermGoal == -1 ? 400 : longTermGoal
    return Double(actualHours) / Double(goal)
  }
  
  var shortTermProgress: Double? {
    guard let shortTermGoal = shortGoal else { return nil }
    let restingHours = shortTermGoal.totalHours - actualHours
    let hoursDone = shortTermGoal.goal - restingHours
    return Double(hoursDone) / Double(shortTermGoal.goal)
  }
  
  var shortTermGoalLabel: String {
    shortGoal?.goal.description ?? "0"
  }
}
