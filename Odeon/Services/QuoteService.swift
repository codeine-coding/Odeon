//
//  QuoteService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 1/23/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class QuoteService {
    
    static let shared = QuoteService()
    var quotes = [Quote]()
    var qotd = [Quote]()
    
    
    func getQuotes(completed: @escaping () -> Void) {
        getData(with: Environment.quotesURL, completed: completed)
    }
    
    func getQuotesOfTheDay(completed: @escaping () -> Void) {
        getData(with: Environment.qotdURL, completed: completed)
    }

    func getData(with url: URL, completed: @escaping () -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            do {
                var results = [Quote]()
                results = try JSONDecoder().decode([Quote].self, from: data)
                if url == Environment.quotesURL {
                    self.quotes = results
                } else {
                    self.qotd = results
                }
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
