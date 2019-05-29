//
//  QuoteListViewController.swift
//  Odeon
//
//  Created by Allen Whearry on 5/29/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit
import GoogleMobileAds

class QuoteListViewController: UIViewController, HasInterstitalAd {


    var quotes: [Quote] = []
    var interstitial: GADInterstitial?
    var destinationController: UINavigationController?
    var cellID = "Quote Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = createAndLoadInterstitial()
        setupView()
    }

    func setupView() {
        displayConstraints()
    }

    func  displayConstraints() {}


    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        guard let destinationController = destinationController else { return }
        present(destinationController, animated: true, completion: nil)
    }

}

extension QuoteListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 108, right: 0)
    }

}

extension QuoteListViewController: QuoteCellDelegate {
    func infoButtonPressed(imdb_id: String) {
        Environment.InfoButtonClickedCount += 1
        let quoteDetailView = QuoteDetailController()
        OMDBService.instance.getFilmInfo(with: imdb_id) {
            quoteDetailView.film = OMDBService.instance.filmOMDB
        }
        destinationController = UINavigationController(rootViewController: quoteDetailView)
        if Environment.InfoButtonClickedCount % 5 == 0 {
            if let interstitial = interstitial, interstitial.isReady {
                print("shwoing ad")
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        } else {
            guard let destinationController = destinationController else { return }
            present(destinationController, animated: true, completion: nil)
        }
    }

    
}
