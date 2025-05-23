//
//  InputSpendingView.swift
//  BudgetBuddy


import SwiftUI

struct InputSpendingView: View {
  @Binding var usedAmount: Double
  @State private var inputAmount: String = ""
  
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var themeProvider: ThemeProvider
  @Environment(\.dismiss) private var dismiss
  var onSave: () -> Void
  
  @State private var showingAlert = false
  @State private var alertMessage = ""
  
  func submitAction() {
    guard let inputDouble = Double(inputAmount), inputDouble >= 0 else {
      alertMessage = "Please enter a valid positive number."
      showingAlert = true
      return
    }
    
    usedAmount += inputDouble
    onSave()
    presentationMode.wrappedValue.dismiss()
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Text("How much did you spend?")
          .font(.largeTitle)
        
        HStack {
          Text("$")
          TextField("Amount", text: $inputAmount)
            .keyboardType(.decimalPad)
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        Button("Submit", action: submitAction)
          .font(.headline)
          .padding()
          .background(Color("BudgetBuddyPrimary"))
          .foregroundColor(.white)
          .cornerRadius(8)
      }
      .padding()
      .navigationBarTitle("Input Spending", displayMode: .inline)
      .alert(isPresented: $showingAlert) {
        Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: {
            dismiss()
          }) {
            Text("Exit")
          }
          .accentColor(.red)
        }
      }
    }
    .colorScheme(themeProvider.isDarkMode ? .dark : .light)
  }
}




