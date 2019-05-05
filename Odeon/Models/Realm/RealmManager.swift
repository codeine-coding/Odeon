//
//  RealmQuoteManager.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/31/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation
import RealmSwift
//import QuoteInfoKit

class RealmManager {
    static let shared = RealmManager()
    var realm = try! Realm()
    var realmURL = Realm.Configuration.defaultConfiguration.fileURL!

    func getBookmarkeQuotes() -> [BookmarkedQuote] {
        guard let bookmarkedQuotes = try? Realm().objects(BookmarkedQuote.self).sorted(byKeyPath: "created", ascending: false) else { return [BookmarkedQuote]() }
        return Array(bookmarkedQuotes)
    }
    
    func createBookmarkedQuote(from quote: Quote) -> BookmarkedQuote {
        let bookmarkedQuote = BookmarkedQuote()
        bookmarkedQuote.quoteID = quote.id
        bookmarkedQuote.content = quote.content
        bookmarkedQuote.author = quote.author
        bookmarkedQuote.filmTitle = quote.film.title
        bookmarkedQuote.filmTypeTitle = quote.film.type.title
        bookmarkedQuote.filmImdb_id = quote.film.imdb_id

        return bookmarkedQuote
    }

    func add(bookmarkedQuote: BookmarkedQuote) {
        try! realm.write {
            realm.add(bookmarkedQuote)
        }
    }
    
    func remove(quote: Quote) {
        guard let bookmark = realm.objects(BookmarkedQuote.self).first(where: { $0.quoteID == quote.id }) else { return }
        try! realm.write {
            realm.delete(bookmark)
        }
    }
    
    func convertToQuote(_ bookmarkedQuote: BookmarkedQuote) -> Quote {
        let entertianmentType = Quote.Film.EntertianmentType.init(title: bookmarkedQuote.filmTypeTitle)
        let film = Quote.Film.init(title: bookmarkedQuote.filmTitle, type: entertianmentType, imdb_id: bookmarkedQuote.filmImdb_id)
        let quote = Quote.init(id: bookmarkedQuote.quoteID, content: bookmarkedQuote.content, author: bookmarkedQuote.author, film: film)
        return quote
    }
    
    func convertAllBookmarkedQuotesToQuote() -> [Quote] {
        return self.getBookmarkeQuotes().map { convertToQuote($0)}
    }
}
