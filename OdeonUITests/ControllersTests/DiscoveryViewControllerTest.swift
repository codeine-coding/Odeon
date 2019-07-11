//
//  DiscoveryViewControllerTest.swift
//  OdeonUITests
//
//  Created by Allen Whearry on 7/10/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import XCTest
@testable import Odeon

class DiscoveryViewControllerTest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testSearcBar_Exists() {
        app.tabBars.buttons["Discover"].tap()
        let searchBar = app.otherElements["Search"]
        XCTAssertTrue(searchBar.exists)
    }
    
    func testSearchBar_WhenResultsFound() {
        app.tabBars.buttons["Discover"].tap()
        XCTAssertFalse(app.isDisplayingNoResultsView)

        let searchBar = app.otherElements["Search"]
        searchBar.tap()
        searchBar.typeText("TV")
        
        XCTAssertTrue(app.collectionViews.cells.count > 0)
        
        
    }
    
    func testSearchBar_WhenNoResults_NoResultsViewIsDisplayed() {
        app.tabBars.buttons["Discover"].tap()
        XCTAssertFalse(app.isDisplayingNoResultsView)
        
        let searchBar = app.otherElements["Search"]
        searchBar.tap()
        searchBar.typeText("askdfa")
        
        XCTAssertTrue(app.collectionViews.cells.count == 0)
        XCTAssertTrue(app.isDisplayingNoResultsView)
    }

}

private extension XCUIApplication {
    var isDisplayingNoResultsView: Bool {
        return otherElements["No Data View"].exists && staticTexts["No Results Found"].exists
    }
}
