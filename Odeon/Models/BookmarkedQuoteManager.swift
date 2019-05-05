//
//  BookmarkedQuoteManager.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/31/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class BookmarkedQuoteManager {
    var bookmarkQuoteCount: Int { return RealmManager.shared.getBookmarkeQuotes().count }
    var allBookmarks: [Quote] { return RealmManager.shared.convertAllBookmarkedQuotesToQuote() }
    
    func convert(_ bookmark: BookmarkedQuote) -> Quote {
        return RealmManager.shared.convertToQuote(bookmark)
    }
    
    func bookmark(_ quote: Quote) {
        let bookmarkedQuote = RealmManager.shared.createBookmarkedQuote(from: quote)
        RealmManager.shared.add(bookmarkedQuote: bookmarkedQuote)
    }
    
    func unbookmark(_ quote: Quote) {
        RealmManager.shared.remove(quote: quote)
    }
}
