//
//  Quote.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 1/23/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import Foundation

struct Quote: Codable, Equatable {
    static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var content: String
     var author: String
    var film: Film
    
    struct Film: Codable {
        var title: String
        var type: EntertianmentType
        var imdb_id: String
        
        struct EntertianmentType: Codable {
            public var title: String
        }
    }
    
}

let sampleQuotes = [
    Quote(id: 1,
          content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium mi sed ullamcorper efficitur. ",
          author: "Lorem Ipsum",
          film: Quote.Film(title: "", type: Quote.Film.EntertianmentType(title: ""), imdb_id: "")),
    Quote(id: 2,
          content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium mi sed ullamcorper efficitur. ",
          author: "Lorem Ipsum",
          film: Quote.Film(title: "", type: Quote.Film.EntertianmentType(title: ""), imdb_id: "")),
    Quote(id: 3,
          content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium mi sed ullamcorper efficitur. ",
          author: "Lorem Ipsum",
          film: Quote.Film(title: "", type: Quote.Film.EntertianmentType(title: ""), imdb_id: "")),
    Quote(id: 4,
          content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pretium mi sed ullamcorper efficitur. ",
          author: "Lorem Ipsum",
          film: Quote.Film(title: "", type: Quote.Film.EntertianmentType(title: ""), imdb_id: ""))
]
