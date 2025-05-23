//
//  ThemeProvider.swift
//  BudgetBuddy


import Foundation
import SwiftUI

class ThemeProvider: ObservableObject {
  @Published var isDarkMode: Bool {
    didSet {
      UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
    }
  }
  
  init() {
    self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
  }
}
