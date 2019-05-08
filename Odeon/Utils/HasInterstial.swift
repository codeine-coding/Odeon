//
//  HasInterstial.swift
//  Odeon
//
//  Created by Allen Whearry on 5/8/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import Foundation
import GoogleMobileAds

protocol HasInterstitalAd: GADInterstitialDelegate {
    func createAndLoadInterstitial() -> GADInterstitial
}

extension HasInterstitalAd {
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Environment.InterstitialAd)
        interstitial.delegate = self
        interstitial.load(TestDeviceRequest)
        return interstitial
    }
}
