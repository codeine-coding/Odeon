//
//  BookmarkedQuote.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/31/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation
import RealmSwift

class BookmarkedQuote: Object {
    @objc dynamic var quoteID: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var filmTitle: String = ""
    @objc dynamic var filmTypeTitle: String = ""
    @objc dynamic var filmImdb_id: String = ""
    @objc dynamic var created = Date()
}
