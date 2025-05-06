//
//  TransactionTests.swift
//  BudgetBuddyTests


import XCTest
@testable import CentSage

final class TransactionTests: XCTestCase {

    var persistenceController: PersistenceController!
    var viewModel: TransactionsViewModel!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory:true)
        viewModel = TransactionsViewModel(context: persistenceController.container.viewContext)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        persistenceController = nil
    }
    
    func testInitialState() throws {
        XCTAssertEqual(viewModel.transactions.count, 0)
        XCTAssertEqual(viewModel.selectedCategory, "All")
        XCTAssertEqual(viewModel.totalAmount, 0)
    }
    
    func testTotalAmountCalculation() throws {
        let context = persistenceController.container.viewContext
        
        //create an expense
        let expense = Transaction(context: context)
        expense.name = "Test expense"
        expense.amount = 100
        expense.category = "Food"
        expense.date = Date()
        expense.id = UUID()
        expense.type = 0
        
        //Create and income
        let income = Transaction(context: context)
        income.name = "Test income"
        income.amount = 200
        income.category = "Work"
        income.date = Date()
        income.id = UUID()
        income.type = 1
        
        try context.save()
        
        NotificationCenter.default.post(name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        
        XCTAssertEqual(viewModel.totalAmount, 100)
    }

    func testCategoryFiltering() throws {
        let context = persistenceController.container.viewContext
        
        // create transactions with different categories
        let transaction1 = Transaction(context: context)
        transaction1.name = "Transaction 1"
        transaction1.amount = 50
        transaction1.category = "Food"
        transaction1.date = Date()
        transaction1.id = UUID()
        transaction1.type = 0
        
        let transaction2 = Transaction(context: context)
        transaction2.name = "Transaction 2"
        transaction2.amount = 123
        transaction2.category = "Transportation"
        transaction2.date = Date()
        transaction2.id = UUID()
        transaction2.type = 0
        
        try context.save()
        
        NotificationCenter.default.post(name:NSNotification.Name.NSManagedObjectContextDidSave, object:context)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        
        XCTAssertEqual(viewModel.transactions.count, 2)
        
        viewModel.selectedCategory = "Food"
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))

        XCTAssertEqual(viewModel.transactions.count, 1)
                XCTAssertEqual(viewModel.transactions.first?.name, "Transaction 1")
                
       // Filter by Transportation category
       viewModel.selectedCategory = "Transportation"
       RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
                
       XCTAssertEqual(viewModel.transactions.count, 1)
       XCTAssertEqual(viewModel.transactions.first?.name, "Transaction 2")
                
       // Reset filter to show all
       viewModel.selectedCategory = "All"
       RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
                
       XCTAssertEqual(viewModel.transactions.count, 2)
    }
    
    func testDeleteTransactions() throws {
            let context = persistenceController.container.viewContext
            
            // Create a transaction
            let transaction = Transaction(context: context)
            transaction.name = "Delete Test"
            transaction.amount = 25
            transaction.category = "Food"
            transaction.date = Date()
            transaction.id = UUID()
            transaction.type = 0
            
            try context.save()
        NotificationCenter.default.post(name: NSNotification.Name.NSManagedObjectContextDidSave, object: context)

            // Verify having 1 transaction
            XCTAssertEqual(viewModel.transactions.count, 1)
            
            // Delete the transaction
            viewModel.deleteTransactions(at: IndexSet(integer: 0))
            
            // Verify it was deleted
            XCTAssertEqual(viewModel.transactions.count, 0)
        }
}
