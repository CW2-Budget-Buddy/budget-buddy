//
//  DotsIndicator.swift
//  BudgetBuddy


import SwiftUI

struct DotsIndicator: View {
  var numberOfPages: Int
  var currentPage: Int
  
  var body: some View {
    HStack {
      ForEach(0..<numberOfPages, id: \.self) { index in
        Circle()
          .frame(width: 10, height: 10)
          .foregroundColor(index == currentPage ? Color("BudgetBuddyPrimary") : .gray)
          .overlay(Circle().stroke(Color.black, lineWidth: 1))
          .padding(.horizontal, 4)
      }
    }
  }
}
