//
//  CustomProgressView.swift
//  BudgetBuddy

import Foundation
import SwiftUI

struct CustomProgressView: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    GeometryReader { geometry in
      let width = geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0)
      
      ZStack(alignment: .leading) {
        Rectangle()
          .frame(width: geometry.size.width, height: geometry.size.height)
          .opacity(0.3)
          .foregroundColor(Color(UIColor.systemGray4))
        
        Rectangle()
          .frame(width: width, height: geometry.size.height)
          .foregroundColor(Color("BudgetBuddyPrimary"))
      }
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color(UIColor.systemGray5), lineWidth: 1)
      )
    }
  }
}

