//
//  CategoryService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class CategoryService {
    typealias CompletionHandler = () -> Void
    static let shared = CategoryService()
    var categories = [Category]()
    
    func getCategories(completed: @escaping CompletionHandler, failure: CompletionHandler? = nil) {
        URLSession.shared.dataTask(with: Environment.categoriesURL) { (data, response, error) in
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
                self.categories = try JSONDecoder().decode([Category].self, from: data)
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
