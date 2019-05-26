//
//  QuoteService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 1/23/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class QuoteService {
    typealias CompletionHandler = ([Quote]?, Error?) -> Void

    static let shared = QuoteService()

    private init() {}

    func getQuotes(completion: @escaping CompletionHandler) {
        NetworkService.shared.get(url: Environment.quotesURL, completion: completion)
    }

    func getQuotesOfTheDay(completion: @escaping CompletionHandler) {
        NetworkService.shared.get(url: Environment.qotdURL, completion: completion)
    }
    
}
