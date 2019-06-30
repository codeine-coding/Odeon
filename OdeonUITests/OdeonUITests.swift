//
//  OdeonUITests.swift
//  OdeonUITests
//
//  Created by Allen Whearry on 5/5/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import XCTest

class OdeonUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeVCCellSwiping() {

        let collectionViewsQuery = XCUIApplication().collectionViews
        XCTAssertTrue(collectionViewsQuery.cells["0"].exists)
        collectionViewsQuery.cells["0"].swipeLeft()
        XCTAssertTrue(collectionViewsQuery.cells["1"].exists)
        collectionViewsQuery.cells["1"].swipeLeft()
        XCTAssertTrue(collectionViewsQuery.cells["2"].exists)
    }

    func testHomeVC_FirstCellInfoButtonPressed_ShowsQuoteFilmInfo() {
        let moreInfo = app.collectionViews.buttons["More Info"]
        XCTAssertTrue(moreInfo.exists)
        moreInfo.tap()

        let poster = app.images["posterImage"]
        XCTAssertTrue(poster.exists)
        XCTAssertFalse(moreInfo.exists)

        app.navigationBars["Odeon.QuoteDetail"].buttons["Done"].tap()
        XCTAssertTrue(moreInfo.exists)
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let tabBarsQuery = app.tabBars
        let categoriesButton = tabBarsQuery.buttons["Categories"]
        categoriesButton.tap()
        tabBarsQuery.buttons["QoTD"].tap()
        snapshot("01QUOTD")
        tabBarsQuery.buttons["Discover"].tap()
        snapshot("O2Discover")
        tabBarsQuery.buttons["Bookmarks"].tap()
        snapshot("03Bookmarks")
        categoriesButton.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Self Confidence"]/*[[".cells.staticTexts[\"Self Confidence\"]",".staticTexts[\"Self Confidence\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("04CategorySelection")

    }

}
