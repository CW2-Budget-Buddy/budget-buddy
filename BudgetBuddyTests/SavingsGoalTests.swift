//
//  SavingsGoalTests.swift
//  BudgetBuddyTests


import XCTest
@testable import CentSage

final class SavingsGoalTests: XCTestCase {

    var persistenceController: PersistenceController!
       var viewModel: SavingsGoalsViewModel!
       
       override func setUpWithError() throws {
           persistenceController = PersistenceController(inMemory: true)
           viewModel = SavingsGoalsViewModel(context: persistenceController.container.viewContext)
       }
       
       override func tearDownWithError() throws {
           viewModel = nil
           persistenceController = nil
       }
       
       func testInitialState() throws {
           XCTAssertEqual(viewModel.goals.count, 0)
       }
       
       func testFetchGoals() throws {
           let context = persistenceController.container.viewContext
           
           // Create a savings goal
           let goal = SavingsGoal(context: context)
           goal.goalName = "Test Goal"
           goal.targetAmount = 1000
           goal.currentAmount = 250
           goal.dueDate = Date().addingTimeInterval(90*24*60*60) // 90 days later
           goal.id = UUID()
           
           try context.save()
           
           // Call public fetchGoals method
           viewModel.fetchGoals()
           
           // Verify the goal was fetched
           XCTAssertEqual(viewModel.goals.count, 1)
           XCTAssertEqual(viewModel.goals.first?.goalName, "Test Goal")
           XCTAssertEqual(viewModel.goals.first?.targetAmount, 1000)
           XCTAssertEqual(viewModel.goals.first?.currentAmount, 250)
       }
       
       func testDeleteGoals() throws {
           let context = persistenceController.container.viewContext
           
           // Create a savings goal
           let goal = SavingsGoal(context: context)
           goal.goalName = "Delete Test"
           goal.targetAmount = 500
           goal.currentAmount = 100
           goal.dueDate = Date().addingTimeInterval(60*24*60*60)
           goal.id = UUID()
           
           try context.save()
           viewModel.fetchGoals()
           
           // Verify having 1 goal
           XCTAssertEqual(viewModel.goals.count, 1)
           
           // Delete the goal
           viewModel.deleteGoals(at: IndexSet(integer: 0))
           
           // Verify it was deleted
           XCTAssertEqual(viewModel.goals.count, 0)
       }

}
