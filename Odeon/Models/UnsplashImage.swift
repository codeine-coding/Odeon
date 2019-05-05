//
//  UnsplashImage.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/17/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

struct Results: Codable {
    var total: Int
    var results: [UnsplashImage]
}

struct UnsplashImage: Codable {
    var id: String
    var urls: URLS
    var links: Links
    var user: User
    
    struct URLS: Codable {
        var raw: String
        var full: String
        var regular: String
        var small: String
        var thumb: String
    }
    
    struct Links: Codable {
        var html: String
    }
    
    struct User: Codable {
        var name: String
    }
}
