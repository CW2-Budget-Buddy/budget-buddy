//
//  SettingsView.swift
//  BudgetBuddy


import CoreData
import SwiftUI

struct SettingsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var themeProvider: ThemeProvider
  
  @State private var showingAlert = false
  @State private var showErrorAlert = false
  
  @State private var errorTitle = ""
  @State private var errorMessage = ""
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Picker("Theme", selection: $themeProvider.isDarkMode) {
            Image(systemName: "sun.max.fill").tag(false)
            Image(systemName: "moon.fill").tag(true)
          }
          .pickerStyle(SegmentedPickerStyle())
        } header: {
          Text("Appearance")
        }
        
        Section {
          customLink(title: "Support", url: "https://sites.google.com/view/CentSage/home")
          customLink(title: "Privacy Policy", url: "https://sites.google.com/view/CentSageprivacypolicy/home")
        } header: {
          Text("Legal")
        }
        
        Section {
          Button(action: {
            showingAlert = true
          }) {
            Text("Delete My Data")
              .foregroundColor(.red)
          }
          .alert(isPresented: $showingAlert) {
            Alert(title: Text("Are you sure?"),
                  message: Text("This will permanently delete all your data. This action can't be undone."),
                  primaryButton: .destructive(Text("Delete")) {
              deleteUserData()
            },
                  secondaryButton: .cancel()
            )
          }
        } header: {
          Text("Data Management")
        }
      }
      .navigationTitle("Settings")
      .alert(isPresented: $showErrorAlert) {
        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    }
  }
  
  func customLink(title: String, url: String) -> some View {
    HStack {
      Text(title)
      Spacer()
      Image(systemName: "arrow.up.right")
        .foregroundColor(.gray)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if let url = URL(string: url) {
        UIApplication.shared.open(url)
      }
    }
  }
  
  func deleteUserData() {
    let entities = ["Budget", "SavingsGoal", "Transaction"]
    
    for entity in entities {
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
      let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      batchDeleteRequest.resultType = .resultTypeObjectIDs
      
      do {
        let deleteResult = try viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
        if let objectIDs = deleteResult?.result as? [NSManagedObjectID] {
          print("found objectIDs and merging changes")
          NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [viewContext])
        } else {
          print("Found no objectIDs and not merging changes.")
        }
      } catch {
        self.errorTitle = "Delete Error"
        self.errorMessage = "There was a problem deleting your data."
        self.showErrorAlert = true
        return
      }
    }
  }
}

#Preview {
  SettingsView()
}
