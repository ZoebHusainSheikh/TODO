//
//  HomeViewControllerTest.swift
//  TodoAppTests
//
//  Created by Best Peers on 11/8/17.
//  Copyright © 2017 Best Peers. All rights reserved.
//

import XCTest
@testable import TodoApp

class HomeViewControllerTest: XCTestCase {
    
    var homeViewController: HomeViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        
        //By fetching the view, the controller is initialised so we dont have to call loadView() to do it and its not even recommended
        let _ = homeViewController?.view
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        homeViewController = nil
    }
    
    func testRegular() {
        
        checkIBOutlets()
        
        //Sorting
        checkSorting()
        
        //Date formatting check
        checkFormatting()
    }
    
    //MARK: Non-Test methods
    
    func checkIBOutlets() {
        XCTAssert(homeViewController?.tableView != nil, "IBOutlet for tableView not connected")
        XCTAssert(homeViewController?.searchTextField != nil, "IBOutlet for searchTextField not connected")
        XCTAssert(homeViewController?.sortButton != nil, "IBOutlet for sortButton not connected")
    }
    
    func checkSorting() {
        homeViewController?.todoList.removeAll()
        
        let task1 = Task()
        task1.priority = 1
        task1.title = "1212"
        homeViewController?.todoList.append(task1)
        let task2 = Task()
        task2.priority = 2
        task2.title = "Alphabets"
        homeViewController?.todoList.append(task2)
        let task3 = Task()
        task3.priority = 3
        task3.title = "#$"
        homeViewController?.todoList.append(task3)
        
        homeViewController?.selectedSort = "Date"
        homeViewController?.sort()
        XCTAssert(homeViewController?.todoList[0] == task1 &&
            homeViewController?.todoList[1] == task2 &&
            homeViewController?.todoList[2] == task3, "Sort with Date failed")
        
        
        homeViewController?.selectedSort = "Priority"
        homeViewController?.sort()
        XCTAssert(homeViewController?.todoList[0] == task3 &&
            homeViewController?.todoList[1] == task2 &&
            homeViewController?.todoList[2] == task1, "Sort with Priority failed")
        
        
        homeViewController?.selectedSort = "Name"
        homeViewController?.sort()
        XCTAssert(homeViewController?.todoList[0] == task3 &&
            homeViewController?.todoList[1] == task1 &&
            homeViewController?.todoList[2] == task2, "Sort with Name failed")
    }
    
    func checkFormatting() {
        let lessThanAMinuteDate: Date = Date().addingTimeInterval(-30)
        let lessThanAMinuteDateString = homeViewController?.getTextToDisplayFormattingDate(date: lessThanAMinuteDate)
        XCTAssert(lessThanAMinuteDateString?.lowercased().trimmingCharacters(in: CharacterSet(charactersIn: " ")) == "just now", "Date formatting for date \'less than a minute\' failed")
        
        let aMinutesDate: Date = Date().addingTimeInterval(-60 * 1)
        let aMinutesDateString = homeViewController?.getTextToDisplayFormattingDate(date: aMinutesDate)
        XCTAssert(aMinutesDateString?.lowercased() == "1 min", "Date formatting for date in a minute failed")
        
        let someMinutesDate: Date = Date().addingTimeInterval(-60 * 4)
        let someMinutesDateString = homeViewController?.getTextToDisplayFormattingDate(date: someMinutesDate)
        XCTAssert(someMinutesDateString?.lowercased() == "4 mins", "Date formatting for date in multiple minutes failed")
        
        let anHoursDate: Date = Date().addingTimeInterval(-60 * 60)
        let anHoursDateString = homeViewController?.getTextToDisplayFormattingDate(date: anHoursDate)
        XCTAssert(anHoursDateString?.lowercased() == "1 hour", "Date formatting for date in an hour failed")
        
        let someHoursDate: Date = Date().addingTimeInterval(-60 * 60 * 2)
        let someHoursDateString = homeViewController?.getTextToDisplayFormattingDate(date: someHoursDate)
        XCTAssert(someHoursDateString?.lowercased() == "2 hours", "Date formatting for date in multiple hours failed")
        
        var someDate = Date(timeIntervalSince1970: 1510137576)
        let fourthDayDate = Date(timeIntervalSince1970: 1509837576)
        let saturdayString = homeViewController?.getTextToDisplayFormattingDate(date: fourthDayDate, withRespectTo: someDate)
        XCTAssert(saturdayString == "Saturday", "Date formatting for date in day format failed")
        
        someDate = Date(timeIntervalSince1970: 1510137576)
        let moreThan6DaysDate = Date(timeIntervalSince1970: 1509437576)
        let moreThan6DaysDateString = homeViewController?.getTextToDisplayFormattingDate(date: moreThan6DaysDate, withRespectTo: someDate)
        XCTAssert(moreThan6DaysDateString == "Oct 31", "Date formatting for date more than 6 days format failed")
    }
    
}
