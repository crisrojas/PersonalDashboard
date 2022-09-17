//
//  TogglProjectRow.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 17/09/2022.
//

import SwiftUI
import SwiftWind

struct TogglProjectRow: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  @State var hoverStar = false
  @State var expanded = false
  @State var shortTermGoal = ""
  let project: TogglProject
  
  private var starColor: Color {
    project.isFavorite || hoverStar
    ? WindColor.yellow.c400
    : WindColor.zinc.c600
  }
  
  var body: some View {
      HStack(spacing: 12) {
        Image(systemName: "star.fill")
          .resizable()
          .size(16)
          .foregroundColor(starColor)
          .onHover { hoverStar = $0 }
          .onTap(perform: toggleFavorite)
        
        Text(project.actualHours.description)
          .width(40)
          .multilineTextAlignment(.trailing)
          .foregroundColor(WindColor.cyan.c100)
        Text(project.name!)
        Spacer()
       
        
        TextField(project.shortTermGoalLabel, text: $shortTermGoal)
          .multilineTextAlignment(.trailing)
          .width(50)
          .onSubmit {
            guard
            let goal = shortTermGoal.toInt32,
            goal > 0
            else { return }
            do {
              let shortTermGoal = TogglShortTermGoal(context: viewContext)
              
              shortTermGoal.totalHours = goal + project.actualHours
              shortTermGoal.goal = goal
              shortTermGoal.project = project
              try viewContext.save()
            } catch {
              // todo
            }
          }
      }
  }
  
  private func makeShortTermGoal() -> Int32 {
    guard let shortTermGoal = shortTermGoal.toInt32 else { return -1 }
    return shortTermGoal + project.actualHours
  }
  
  private func toggleFavorite() {
    project.isFavorite.toggle()
    do {
      try viewContext.save()
    } catch {
      // todo
    }
  }
}


struct SwiftUIView_Previews: PreviewProvider {
  
    static var previews: some View {
      let context = PersistenceController.previewContext
      let project = TogglProject(context: context)
      project.id = 0
      project.name = "Ejercicio"
      project.actualHours = 15
      project.isFavorite = true
      
      return
      TogglProjectRow(
        expanded: true,
        project: project
      )
      .padding()
      .width(500)
      .previewLayout(.sizeThatFits)
      
    }
}
