//
//  ColoredTitleView.swift
//  BudgetBuddy


import SwiftUI

struct ColoredTitleView: View {
  var body: some View {
    HStack {
      Text("Welcome to")
      Text("BBuddy").foregroundColor(Color("BudgetBuddyPrimary"))
    }
    .font(.largeTitle)
    .bold()
  }
}

#Preview {
  ColoredTitleView()
}
