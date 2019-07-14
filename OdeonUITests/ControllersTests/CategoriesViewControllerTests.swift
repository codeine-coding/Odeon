//
//  CategoriesViewControllerTests.swift
//  OdeonUITests
//
//  Created by Allen Whearry on 7/14/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import XCTest
@testable import Odeon

class CategoriesViewControllerTests: XCTestCase {
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

    func testCategoriesVC_Exists() {
        app.tabBars.buttons["Categories"].tap()
        XCTAssertTrue(app.navigationBars["Odeon.Categories"].exists)
    }
    
    func testSelectCategorie_NavigatesTo_CategoryDetailView() {
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells["Cell0"].tap()
        
        XCTAssertTrue(app.navigationBars["Odeon.CategoryDetailView"].exists)
        
    }
    
    func testCategoryDetailView_CanDismissBackTo_CategoriesViewController() {
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells["Cell0"].tap()
        app.navigationBars.buttons["Categories"].tap()
        
        // TODO - CategoryDetailView still exists.
//        XCTAssertTrue(app.navigationBars["Odeon.CategoryDetailView"].exists)
    }
    
    func testSearchBar_DoesNotExist_OnControllerLoad() {
        app.tabBars.buttons["Categories"].tap()
        let searchBar = app.otherElements["Search"]
        XCTAssertFalse(searchBar.exists)
    }
    
    func testSearchBar_ExistsOn_ScrollViewSwipeDown() {
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells["Cell0"].swipeDown()
        
        let searchBar = app.otherElements["Search"]
        XCTAssertTrue(searchBar.exists)
//        app2.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["We Can Change The World"]/*[[".cells[\"Cell0\"].staticTexts[\"We Can Change The World\"]",".cells[\"We Can Change The World\"].staticTexts[\"We Can Change The World\"]",".staticTexts[\"We Can Change The World\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        
    }
    
    func testSearchBar_WithInvalidText_ShowsNoDataView() {
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells["Cell0"].swipeDown()
        
        let searchBar = app.otherElements["Search"]
        searchBar.tap()
        searchBar.typeText("alskdjfa")
        
        XCTAssertTrue(app.isDisplayingNoResultsView)
    }
    
    func testSearchBar_WithValidText_ShowsNoDataView() {
        app.tabBars.buttons["Categories"].tap()
        app.collectionViews.cells["Cell0"].swipeDown()
        
        let searchBar = app.otherElements["Search"]
        searchBar.tap()
        searchBar.typeText("face")
        
        XCTAssertTrue(app.collectionViews.cells.count > 0)
    }

}

private extension XCUIApplication {
    var isDisplayingNoResultsView: Bool {
        return otherElements["No Data View"].exists && staticTexts["No Results Found"].exists
    }
}
