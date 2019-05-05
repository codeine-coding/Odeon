//
//  Category.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

struct Category: Codable {
    var name: String
    var image_url: String?
    var quotes: [Quote]?
    var red: Int
    var blue: Int
    var green: Int
}
