//
//  QuoteTest.swift
//  OdeonTests
//
//  Created by Allen Whearry on 6/28/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import XCTest
@testable import Odeon

class QuoteTest: XCTestCase {
    var quote: Quote!

    override func setUp() {
        super.setUp()
        let entertainmentType = Quote.Film.EntertianmentType(title: "Movie")
        let film = Quote.Film(title: "Title", type: entertainmentType, imdb_id: "1111")
        quote = Quote(id: 1, content: "Some Text", author: "My Self", film: film)
    }

    override func tearDown() {
        quote = nil
    }

    func testQuoteHasId() {
        XCTAssertNotNil(quote.id)
        XCTAssertEqual(quote.id, 1)
    }

    func testQuoteHasContent() {
        XCTAssertNotNil(quote.author)
        XCTAssertEqual(quote.content, "Some Text")
    }

    func testQuoteHasAuthor() {
        XCTAssertNotNil(quote.author)
        XCTAssertEqual(quote.author, "My Self")
    }

    func testQuoteHasFilm() {
        XCTAssertNotNil(quote.film)
    }

    func testQuoteHasFilmTitle() {
        XCTAssertNotNil(quote.film.title)
        XCTAssertEqual(quote.film.title, "Title")
    }

    func testQuoteHasFilmImdbId() {
        XCTAssertNotNil(quote.film.imdb_id)
        XCTAssertEqual(quote.film.imdb_id, "1111")
    }

    func testQuoteFilmHasEntertainmentType() {
        XCTAssertNotNil(quote.film.type)
    }

    func testQuoteHasFilmTypeTitle() {
        XCTAssertNotNil(quote.film.type.title)
        XCTAssertEqual(quote.film.type.title, "Movie")
    }
}
