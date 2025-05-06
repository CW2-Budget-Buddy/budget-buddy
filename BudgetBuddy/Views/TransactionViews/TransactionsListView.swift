//
//  TransactionsListView.swift
//  BudgetBuddy


import SwiftUI
import CoreData

struct TransactionsListView: View {
  @StateObject private var viewModel: TransactionsViewModel
  
  @State private var isShowingNewTransactionView = false
  
  init(context: NSManagedObjectContext) {
    _viewModel = StateObject(wrappedValue: TransactionsViewModel(context: context))
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Picker("Category", selection: $viewModel.selectedCategory) {
          Text("All").tag("All")
          Text("Food").tag("Food")
          Text("Home").tag("Home")
          Text("Work").tag("Work")
          Text("Transportation").tag("Transportation")
          Text("Entertainment").tag("Entertainment")
          Text("Leisure").tag("Leisure")
          Text("Health").tag("Health")
          Text("Gift").tag("Gift")
          Text("Shopping").tag("Shopping")
          Text("Investment").tag("Investment")
          Text("Other").tag("Other")
        }
        .pickerStyle(MenuPickerStyle())
        .padding([.horizontal, .top])
        
        if !viewModel.transactions.isEmpty {
          ExpensePieChartView(transactions: viewModel.transactions)
            .frame(height: 250)
            .padding(.horizontal)
        }
        
        Spacer()
        
        if viewModel.transactions.isEmpty {
          emptyTransactionsView
        } else {
          transactionListView
        }
      }
      .navigationViewStyle(StackNavigationViewStyle())
      .navigationTitle("Transactions")
      .navigationBarItems(
        leading: EditButton(),
        trailing: Button(action: {
          isShowingNewTransactionView = true
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
        }
      )
      .sheet(isPresented: $isShowingNewTransactionView) {
        NewTransactionView()
      }
    }
  }
  
  var emptyTransactionsView: some View {
    VStack {
      Spacer()
      
      Image(systemName: "plus.circle.fill")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .foregroundColor(.gray)
        .padding()
      Text("No transactions yet!")
        .font(.headline)
        .padding(.bottom, 1)
      Text("Tap on the + button to add a new transaction.")
        .font(.subheadline)
        .foregroundColor(.gray)
      
      Spacer()
    }
    .padding()
  }
  
  var transactionListView: some View {
    List {
      if !viewModel.transactions.isEmpty {
        Text("Total: \(viewModel.totalAmount < 0 ? "-" : "")$\((abs(viewModel.totalAmount)), specifier: "%.2f")")
          .font(.headline)
          .padding(5)
      }
      
      ForEach(viewModel.transactions, id: \.self) { transaction in
        TransactionRow(transaction: transaction)
      }
      .onDelete(perform: viewModel.deleteTransactions)
    }
  }
}

struct ExpensePieChartView: View {
  var transactions: [Transaction]
  
  private var expenseData: [ExpenseData] {
    let expenses = transactions.filter { $0.type == 0 } // Only expenses
    let grouped = Dictionary(grouping: expenses, by: { $0.category ?? "Other" })
    
    return grouped.map { key, values in
      let total = values.reduce(0) { $0 + $1.amount }
      return ExpenseData(category: key, amount: total, color: color(for: key))
    }.sorted { $0.amount > $1.amount }
  }
  
  private var totalExpenses: Double {
    expenseData.reduce(0) { $0 + $1.amount }
  }
  
  var body: some View {
    VStack {
      if !expenseData.isEmpty {
        HStack(spacing: 0) {
          // Pie Chart
          ZStack {
            ForEach(Array(expenseData.enumerated()), id: \.element.category) { index, data in
              let startAngle = angle(for: index)
              let endAngle = angle(for: index + 1)
              
              PieSlice(startAngle: startAngle, endAngle: endAngle)
                .fill(data.color)
                .overlay(
                  PieSlice(startAngle: startAngle, endAngle: endAngle)
                    .stroke(Color.white, lineWidth: 1)
                )
            }
          }
          .frame(width: 120, height: 120)
          .padding()
          
          // Legend
          VStack(alignment: .leading, spacing: 8) {
            ForEach(expenseData.prefix(5), id: \.category) { data in
              HStack {
                Circle()
                  .fill(data.color)
                  .frame(width: 12, height: 12)
                Text(data.category)
                  .font(.caption)
                Spacer()
                Text("\(Int((data.amount / totalExpenses) * 100))%")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
            
            if expenseData.count > 5 {
              Text("+ \(expenseData.count - 5) more")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
          .padding(.leading, 10)
        }
        
        Text("Total Expenses: $\(totalExpenses, specifier: "%.2f")")
          .font(.subheadline)
          .padding(.top, 5)
      }
    }
  }
  
  private func angle(for index: Int) -> Angle {
    guard totalExpenses > 0 else { return .degrees(0) }
    let percent = expenseData.prefix(index).reduce(0) { $0 + $1.amount } / totalExpenses
    return .degrees(percent * 360)
  }
  
  private func color(for category: String) -> Color {
    switch category {
    case "Food": return .green
    case "Home": return .blue
    case "Work": return .gray
    case "Transportation": return .orange
    case "Entertainment": return .purple
    case "Leisure": return .yellow
    case "Health": return .red
    case "Gift": return .pink
    case "Shopping": return .mint
    case "Investment": return .indigo
    default: return .secondary
    }
  }
}

struct ExpenseData: Identifiable {
  let id = UUID()
  let category: String
  let amount: Double
  let color: Color
}

struct PieSlice: Shape {
  var startAngle: Angle
  var endAngle: Angle
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2
    
    path.move(to: center)
    path.addArc(
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: false
    )
    path.closeSubpath()
    
    return path
  }
}

#Preview {
  TransactionsListView(context: PersistenceController.preview.container.viewContext)
}
