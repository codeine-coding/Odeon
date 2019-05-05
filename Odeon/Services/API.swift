//
//  API.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/17/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

struct API {
    // Quotes
    static let QuotesURL: String = "https://quiet-sierra-58217.herokuapp.com/api/quotes/"
    static let QotdURL: String = "https://quiet-sierra-58217.herokuapp.com/api/quotes/qotd"
    // Categories
    static let CategoriesURL: String = "https://quiet-sierra-58217.herokuapp.com/api/categories/"

    // Unsplash
    static let USAccessKey: String = "7bc481fffb84e281713aa09ae955ee899d7a079752d10af43d05205f1bd8f545"
    static let USSecretKey: String = "771b76ea00400e34bc2fcd92ebcbb5f41ebd24cfdbf6e2e10ccc2f40cf39e0a5"
    static let USPhotosURL: String = "https://api.unsplash.com/photos"
    static let USSearchPhotosURL: String = "https://api.unsplash.com/search/photos?query="
    
    // OMDB
    static let OMDBApiKey: String = "aec69f1e"
    
    // AdMob
    static var InfoButtonClickedCount: Int = 0
    struct AdMob {
        static let testDevice = [ "d61a2f834f47d41f5beceaa02715e221" ]
        static let AppId: String = "ca-app-pub-9537695112430141~8331033971"
        static let InterstitialAddUnitID: String = "ca-app-pub-9537695112430141/9156072628"
        static let CategoryBannerAdUnitID: String = "ca-app-pub-9537695112430141/4883593616"
    }
    
    struct TestAdMob {
        static let Banner: String = "ca-app-pub-3940256099942544/2934735716"
        static let Interstitial: String = "ca-app-pub-3940256099942544/4411468910"
    }
}
