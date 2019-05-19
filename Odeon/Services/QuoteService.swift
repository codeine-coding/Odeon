//
//  QuoteService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 1/23/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class QuoteService {
    typealias CompletionHandler = () -> Void
    
    static let shared = QuoteService()
    var quotes = [Quote]()
    var qotd = [Quote]()
    
    
    func getQuotes(completed: @escaping CompletionHandler, failure: CompletionHandler? = nil) {
        getData(with: Environment.qotdURL, completed: completed, failure: failure)
    }
    
    func getQuotesOfTheDay(completed: @escaping CompletionHandler,  failure: CompletionHandler? = nil) {
        getData(with: Environment.qotdURL, completed: completed, failure: failure)
    }

    func getData(with url: URL, completed: @escaping CompletionHandler, failure: CompletionHandler? = nil) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                if let failure = failure {
                    DispatchQueue.main.async {
                        failure()
                    }
                }
                return
            }

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
