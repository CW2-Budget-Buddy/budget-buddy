//
//  BudgetBuddyUITests.swift
//  BudgetBuddyUITests

import XCTest

final class BudgetBuddyUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    func testTabBarNavigation() throws {
            // Verify all main tabs are accessible
            XCTAssertTrue(app.tabBars.buttons["Transactions"].exists)
            XCTAssertTrue(app.tabBars.buttons["Budgets"].exists)
            XCTAssertTrue(app.tabBars.buttons["Goals"].exists)
            XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
            
            // Navigate through tabs
            app.tabBars.buttons["Budgets"].tap()
            XCTAssertTrue(app.navigationBars["Budgets"].exists)
            
            app.tabBars.buttons["Goals"].tap()
            XCTAssertTrue(app.navigationBars["Savings Goals"].exists)
            
            app.tabBars.buttons["Settings"].tap()
            // Verify Settings screen elements (adjust based on your UI)
            XCTAssertTrue(app.switches["Dark Mode"].exists)
            
            app.tabBars.buttons["Transactions"].tap()
            XCTAssertTrue(app.navigationBars["Transactions"].exists)
        }
    
    func testAddTransaction() throws {
            // Navigate to transactions
            app.tabBars.buttons["Transactions"].tap()
            
            // Tap add button
            app.navigationBars["Transactions"].buttons["Add"].tap()
            
            // Fill in transaction details
            let nameTextField = app.textFields["Name"]
            XCTAssertTrue(nameTextField.waitForExistence(timeout: 2))
            nameTextField.tap()
            nameTextField.typeText("Coffee")
            
            let amountTextField = app.textFields["Amount"]
            amountTextField.tap()
            amountTextField.typeText("4.50")
            
            // Select expense type (should be default)
            app.segmentedControls.buttons["Expense"].tap()
            
            // Select category
            app.buttons["Category"].tap()
            app.pickerWheels.element.adjust(toPickerWheelValue: "Food")
            
            // Save transaction
            app.buttons["Save"].tap()
            
            // Verify transaction appears in list
            XCTAssertTrue(app.staticTexts["Coffee"].exists)
            XCTAssertTrue(app.staticTexts["$4.50"].exists)
        }
        
        func testDeleteTransaction() throws {
            
         
                // First add a transaction
            try testAddTransaction()
                
                // Enter edit mode
                app.navigationBars["Transactions"].buttons["Edit"].tap()
                
                // Delete the transaction
                let deleteButton = app.buttons["Delete Coffee"]
                XCTAssertTrue(deleteButton.exists)
                deleteButton.tap()
                
                // Confirm deletion
                app.buttons["Delete"].tap()
                
                // Exit edit mode
                app.navigationBars["Transactions"].buttons["Done"].tap()
                
                // Verify transaction is gone
                XCTAssertFalse(app.staticTexts["Coffee"].exists)
            
        }
        
        // MARK: - Budget Tests
        
        func testAddBudget() throws {
            // Navigate to budgets
            app.tabBars.buttons["Budgets"].tap()
            
            // Tap add button
            app.navigationBars["Budgets"].buttons["Add"].tap()
            
            // Fill in budget details
            let nameTextField = app.textFields["Name"]
            XCTAssertTrue(nameTextField.waitForExistence(timeout: 2))
            nameTextField.tap()
            nameTextField.typeText("Monthly Groceries")
            
            let amountTextField = app.textFields["Budget Amount"]
            amountTextField.tap()
            amountTextField.typeText("300")
            
            // Enable dates
            app.switches["Include Dates"].tap()
            
            // Save budget
            app.buttons["Save"].tap()
            
            // Verify budget appears in list
            XCTAssertTrue(app.staticTexts["Monthly Groceries"].exists)
            XCTAssertTrue(app.staticTexts["Total Budget: $300.00"].exists)
        }
        
        func testUpdateBudgetSpending() throws {
            // First add a budget
            try testAddBudget()
            
            // Tap on the budget to update spending
            app.staticTexts["Monthly Groceries"].tap()
            
            // Enter amount spent
            let amountTextField = app.textFields["Amount"]
            XCTAssertTrue(amountTextField.waitForExistence(timeout: 2))
            amountTextField.tap()
            amountTextField.typeText("150")
            
            // Submit
            app.buttons["Submit"].tap()
            
            // Verify updated amount
            XCTAssertTrue(app.staticTexts["Remaining: $150.00"].exists)
        }
        
        // MARK: - Savings Goal Tests
        
        func testAddSavingsGoal() throws {
            // Navigate to goals
            app.tabBars.buttons["Goals"].tap()
            
            // Tap add button
            app.navigationBars["Savings Goals"].buttons["Add"].tap()
            
            // Fill in goal details
            let nameTextField = app.textFields["Goal Name"]
            XCTAssertTrue(nameTextField.waitForExistence(timeout: 2))
            nameTextField.tap()
            nameTextField.typeText("New Laptop")
            
            let targetTextField = app.textFields["Target Amount"]
            targetTextField.tap()
            targetTextField.typeText("1500")
            
            let currentTextField = app.textFields["Current Amount"]
            currentTextField.tap()
            currentTextField.typeText("500")
            
            // Enable due date
            app.switches["Include Due Date"].tap()
            
            // Save goal
            app.buttons["Save"].tap()
            
            // Verify goal appears in list
            XCTAssertTrue(app.staticTexts["New Laptop"].exists)
            XCTAssertTrue(app.staticTexts["Target: $1500.00"].exists)
            XCTAssertTrue(app.staticTexts["Current: $500.00"].exists)
        }
        
        func testUpdateSavingsGoal() throws {
            // First add a savings goal
            try testAddSavingsGoal()
            
            // Tap on the goal to update
            app.staticTexts["New Laptop"].tap()
            
            // Enter new savings amount
            let amountTextField = app.textFields["Amount"]
            XCTAssertTrue(amountTextField.waitForExistence(timeout: 2))
            amountTextField.tap()
            amountTextField.typeText("200")
            
            // Submit
            app.buttons["Submit"].tap()
            
            // Verify updated amount (should now be $700)
            XCTAssertTrue(app.staticTexts["Current: $700.00"].exists)
        }
        
        // MARK: - Theme Tests
        
        func testToggleDarkMode() throws {
            // Navigate to settings
            app.tabBars.buttons["Settings"].tap()
            
            // Get initial state of dark mode toggle
            let darkModeSwitch = app.switches["Dark Mode"]
            XCTAssertTrue(darkModeSwitch.exists)
            let initialValue = darkModeSwitch.value as! String
            
            // Toggle dark mode
            darkModeSwitch.tap()
            
            // Verify the toggle changed
            let newValue = darkModeSwitch.value as! String
            XCTAssertNotEqual(initialValue, newValue)
            
            // Toggle back
            darkModeSwitch.tap()
            
            // Verify we're back to the initial state
            let finalValue = darkModeSwitch.value as! String
            XCTAssertEqual(initialValue, finalValue)
        }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
