//
//  HomeViewControllerTests.swift
//  OdeonUITests
//
//  Created by Allen Whearry on 7/2/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import XCTest
@testable import Odeon

class HomeViewControllerTests: XCTestCase {
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
    }

    func testHomeVC_IsFirstVCLoaded() {
        XCTAssertTrue(app.collectionViews["QOTD Collection View"].exists)
    }

    func testWhenCellInfoButtonPressed_PresentsQuoteFilmInfo() {
        let moreInfo = app.collectionViews.buttons["More Info"]
        XCTAssertTrue(moreInfo.exists)
        moreInfo.tap()

        let poster = app.images["posterImage"]
        XCTAssertTrue(poster.exists)
        XCTAssertFalse(moreInfo.exists)

        app.navigationBars["Odeon.QuoteDetail"].buttons["Done"].tap()
        XCTAssertTrue(moreInfo.exists)
    }

    func testCellsSwipable() {
        let collectionViewsQuery = app.collectionViews
        XCTAssertTrue(collectionViewsQuery.cells["0"].exists)
        collectionViewsQuery.cells["0"].swipeLeft()
        XCTAssertTrue(collectionViewsQuery.cells["1"].exists)
        collectionViewsQuery.cells["1"].swipeLeft()
        XCTAssertTrue(collectionViewsQuery.cells["2"].exists)
    }

    // TODO: Test Bookmarking

}
