//
//  Environment.swift
//  Odeon
//
//  Created by Allen Whearry on 5/7/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import Foundation

public enum Environment {

    enum Keys {
        enum Plist {
            // Odeon
            static let quotesURL = "QUOTES_URL"
            static let quotdURL = "QOTD_URL"
            static let categoriesURL = "CATEGORIES_URL"

            // Unsplash
            static let unsplashAccessKey = "UNSPLASH_ACESS_KEY"
            static let unsplashSecretKey = "UNSPLASH_SECRET_KEY"

            // OMDB
            static let ombdApiKey = "OMDB_API_KEY"

            // AdMob
            static let admobAppID = "ADMOB_APP_ID"
            static let admobTestDevice = "ADMOB_TEST_DEVICE"
            static let categoryBannerAdUnitID = "CATEGORY_BANNER_AD_UNIT_ID"
            static let interstitialAdUnitID = "INTERSTITIAL_AD_UNIT_ID"
        }
    }

    // Odeon
    static let quotesURL: URL = {
        return getURL(with: Keys.Plist.quotesURL, for: "Quotes URL")
    }()

    static let qotdURL: URL = {
        return getURL(with: Keys.Plist.quotdURL, for: "QOTD URL")
    }()

    static let categoriesURL: URL = {
        return getURL(with: Keys.Plist.categoriesURL, for: "Categories URL")
    }()

    // Unsplash
    static let USAccessKey: String = {
        guard let apiKey = Environment.infoForKey(Keys.Plist.unsplashAccessKey) else {
            fatalError("Unsplash Access Key not set in plist for this environment")
        }
        return apiKey
    }()

    static let USSecretKey: String = {
        guard let secretKey = Environment.infoForKey(Keys.Plist.unsplashSecretKey) else {
            fatalError("Unsplash Secret Key not set in plist for this environment")
        }
        return secretKey
    }()

    // OMDB
    static let OMDBApiKey: String = {
        guard let apiKey = Environment.infoForKey(Keys.Plist.ombdApiKey) else {
            fatalError("OMDB Api Key not set in plist for this environment")
        }
        return apiKey
    }()

    // ADMOB
    static let testDevice: String = {
        guard let td = Environment.infoForKey(Keys.Plist.admobTestDevice) else {
            fatalError("AdMob Test Device string not set in plist for this environment")
        }
        return td
    }()

    static let categoryBannerAd: String = {
        guard let unitID = Environment.infoForKey(Keys.Plist.categoryBannerAdUnitID) else {
            fatalError("Admob Category Banner Ad Unit Id not set in plist for this environment")
        }
        return unitID
    }()

    static let InterstitialAd: String = {
        guard let unitID = Environment.infoForKey(Keys.Plist.interstitialAdUnitID) else {
            fatalError("Admob Category Banner Ad Unit Id not set in plist for this environment")
        }
        return unitID
    }()


    private static func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }

    private static func getURL(with keyString: String, for errorMessage: String) -> URL {
        guard let urlString = Environment.infoForKey(keyString) else {
            fatalError("\(errorMessage) not set in plist for this environment")
        }
        guard let url = URL(string: urlString) else {
            fatalError("URL is Invalid")
        }
        return url
    }
}
