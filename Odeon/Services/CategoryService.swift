//
//  CategoryService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class CategoryService {
    static let shared = CategoryService()
    var categories = [Category]()
    
    func getCategories(completed: @escaping () -> Void) {
        URLSession.shared.dataTask(with: Environment.categoriesURL) { (data, response, error) in
            guard let data = data else { return }
            
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
