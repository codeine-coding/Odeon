//
//  OdeonTests.swift
//  OdeonTests
//
//  Created by Allen Whearry on 4/30/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import XCTest
@testable import Odeon

class OdeonTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOdeonServerConnection() {
        // Given
        let url = Environment.quotesURL
        let session = URLSession(configuration: .default)
        let promise = expectation(description: "Response: 200")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                XCTAssert(false, "There was an error: \(error!.localizedDescription)")
                return
            }
            
            if let status = (response as? HTTPURLResponse)?.statusCode {
                if status == 200 {
                    promise.fulfill()
                } else {
                    XCTAssert(false, "The Returned code was: \(status)")
                }
            }
        }
        task.resume()
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
