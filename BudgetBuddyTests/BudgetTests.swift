//
//  BudgetTests.swift
//  BudgetBuddyTests


import XCTest
@testable import CentSage

final class BudgetTests: XCTestCase {

    var persistenceController: PersistenceController!
        var viewModel: BudgetsViewModel!
        
        override func setUpWithError() throws {
            persistenceController = PersistenceController(inMemory: true)
            viewModel = BudgetsViewModel(context: persistenceController.container.viewContext)
        }
        
        override func tearDownWithError() throws {
            viewModel = nil
            persistenceController = nil
        }
        
        func testInitialState() throws {
            XCTAssertEqual(viewModel.budgets.count, 0)
        }
        
        func testFetchBudgets() throws {
            let context = persistenceController.container.viewContext
            
            // Create a budget
            let budget = Budget(context: context)
            budget.name = "Test Budget"
            budget.amount = 500
            budget.usedAmount = 200
            budget.startDate = Date()
            budget.endDate = Date().addingTimeInterval(30*24*60*60) // 30 days later
            budget.id = UUID()
            
            try context.save()
            
            // Call public fetchBudgets method
            viewModel.fetchBudgets()
            
            // Verify the budget was fetched
            XCTAssertEqual(viewModel.budgets.count, 1)
            XCTAssertEqual(viewModel.budgets.first?.name, "Test Budget")
            XCTAssertEqual(viewModel.budgets.first?.amount, 500)
            XCTAssertEqual(viewModel.budgets.first?.usedAmount, 200)
        }
        
        func testDeleteBudgets() throws {
            let context = persistenceController.container.viewContext
            
            // Create a budget
            let budget = Budget(context: context)
            budget.name = "Delete Test"
            budget.amount = 300
            budget.usedAmount = 100
            budget.startDate = Date()
            budget.endDate = Date().addingTimeInterval(30*24*60*60)
            budget.id = UUID()
            
            try context.save()
            viewModel.fetchBudgets()
            
            // Verify we have 1 budget
            XCTAssertEqual(viewModel.budgets.count, 1)
            
            // Delete the budget
            viewModel.deleteBudgets(at: IndexSet(integer: 0))
            
            // Verify it was deleted
            XCTAssertEqual(viewModel.budgets.count, 0)
        }

}
