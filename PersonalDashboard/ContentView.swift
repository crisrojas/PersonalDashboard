//
//  ContentView.swift
//  PersonalDashboard
//
//  Created by Cristian Rojas on 12/09/2022.
//

import SwiftUI
import CoreData
import KeychainSwift

/*
@ TODO:
 - Make home default view
 - Use Composable Architecture?
 - Use Moya ? 
 */
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
  
  

    var body: some View {
        NavigationView {
            List {
              
              NavigationLink {
              Text("Home")
              } label: {
                Text("Home")
              }
              
              NavigationLink {
                TogglView()
              } label: {
                Text("Toggl")
              }
            }

        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  return decoder
}()

