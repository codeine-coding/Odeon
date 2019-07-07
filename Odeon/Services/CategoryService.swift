//
//  CategoryService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class CategoryService {
    typealias CompletionHandler = (Result<[Category], Error>) -> Void

    static let shared = CategoryService()

    private init() {}
    
    func getCategories(completion: @escaping CompletionHandler) {
        NetworkService.shared.get(url: Environment.categoriesURL, completion: completion)
    }
    
}
