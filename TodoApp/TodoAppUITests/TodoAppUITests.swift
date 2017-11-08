//
//  TodoAppUITests.swift
//  TodoAppUITests
//
//  Created by Best Peers on 07/11/17.
//  Copyright © 2017 Best Peers. All rights reserved.
//

import XCTest

class TodoAppUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddTask(){
        let app = XCUIApplication()
        let addButton = app.navigationBars["TODO"].buttons["Add"]
        addButton.tap()
        
        let newTaskAlert = app.alerts["New Task"]
        let taskNameTextField = newTaskAlert.collectionViews.textFields["taskNametextField"]
        taskNameTextField.typeText("Task 1")
        
        let addButton2 = newTaskAlert.buttons["Add"]
        addButton2.tap()
        addButton.tap()
        taskNameTextField.tap()
        taskNameTextField.typeText("Take Cofee")
        addButton2.tap()
        addButton.tap()
        taskNameTextField.typeText("Take Shower")
        addButton2.tap()
        XCTAssert(app.tables.cells.count > 0)
    }
    
    func testChangePriority() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        tablesQuery.cells.element(boundBy: 0)/*@START_MENU_TOKEN@*/.buttons["priorityButton"]/*[[".buttons[\"!!\"]",".buttons[\"priorityButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let selectPrioritySheet = app.sheets["Select Priority"]
        let lowButton = selectPrioritySheet.buttons["Low"]
        lowButton.tap()
        
        tablesQuery.cells.element(boundBy: 1)/*@START_MENU_TOKEN@*/.buttons["priorityButton"]/*[[".buttons[\"!!\"]",".buttons[\"priorityButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let highButton = selectPrioritySheet.buttons["High"]
        highButton.tap()
        
        tablesQuery.cells.element(boundBy: 2)/*@START_MENU_TOKEN@*/.buttons["priorityButton"]/*[[".buttons[\"!!\"]",".buttons[\"priorityButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        lowButton.tap()
        
        tablesQuery.cells.element(boundBy: 0)/*@START_MENU_TOKEN@*/.buttons["priorityButton"]/*[[".buttons[\"!!\"]",".buttons[\"priorityButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let normalButton = selectPrioritySheet.buttons["Normal"]
        normalButton.tap()
        
    }
    
    func testModifyTask() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        let cell = tablesQuery.cells.element(boundBy: 0)
        cell.tap()
        
        let updateTaskAlert = app.alerts["Change Task"]
        let taskNameTextField = updateTaskAlert.collectionViews.textFields["taskNametextField"]
        taskNameTextField.typeText("Updated Task")
        let updateButton = updateTaskAlert.buttons["Update"]
        updateButton.tap()
        
        testSearchTask()
    }
    
    func testSearchTask() {
        let app = XCUIApplication()
        let searchtextfieldTextField = app/*@START_MENU_TOKEN@*/.textFields["searchTextField"]/*[[".textFields[\"Search\"]",".textFields[\"searchTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        searchtextfieldTextField.tap()
        
        searchtextfieldTextField.typeText("task")
        let clearTextButton = app/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".textFields[\"Search\"].buttons[\"Clear text\"]",".textFields[\"searchTextField\"].buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        clearTextButton.tap()
        
        searchtextfieldTextField.typeText("take")
        clearTextButton.tap()
        
        searchtextfieldTextField.typeText("take c")
        clearTextButton.tap()
        
        searchtextfieldTextField.typeText("Update")
        clearTextButton.tap()
        
    }
    
    func testSortBy() {
        let app = XCUIApplication()
        let sortbuttonButton = app/*@START_MENU_TOKEN@*/.buttons["sortButton"]/*[[".buttons[\"Date\"]",".buttons[\"sortButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sortbuttonButton.tap()
        
        let sortBySheet = app.sheets["Sort By"]
        let nameButton = sortBySheet.buttons["Name"]
        nameButton.tap()
        
        sortbuttonButton.tap()
        
        let priorityButton = sortBySheet.buttons["Priority"]
        priorityButton.tap()
        
        sortbuttonButton.tap()
        sortBySheet.buttons["Date"].tap()
        
        let searchtextfieldTextField = app/*@START_MENU_TOKEN@*/.textFields["searchTextField"]/*[[".textFields[\"Search\"]",".textFields[\"searchTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        searchtextfieldTextField.tap()
        searchtextfieldTextField.typeText("ta")
        
        sortbuttonButton.tap()
        priorityButton.tap()
        
        sortbuttonButton.tap()
        nameButton.tap()
    }
    
    func testTaskDelete() {
        let app = XCUIApplication()
        let tablesQuery = app.tables.cells
        let firstCell = tablesQuery.element(boundBy: 0)
        firstCell.swipeLeft()
        firstCell.buttons["Delete"].tap()
        
        let secondCell = tablesQuery.element(boundBy: 1)
        secondCell.swipeLeft()
        secondCell.buttons["Delete"].tap()
        
        testSearchTask()
    }
    
}
