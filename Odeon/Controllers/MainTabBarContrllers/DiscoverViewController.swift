//
//  DiscoverViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/27/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DiscoverViewController: UIViewController {
    
    var interstitial: GADInterstitial!
    let cellID = "CellID"
    var destinationController: UINavigationController?
    var bookmarkManager = BookmarkedQuoteManager()
    
    var filteredQuotes: [Quote] = [] {
        didSet {
            if isFiltering() {
                self.resultsCountLabel.alpha = 1
            }
            if !filteredQuotes.isEmpty {
                self.resultsCountLabel.text = "Showing \(filteredQuotes.count) results"
            } else {
                self.resultsCountLabel.alpha = 0
            }
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search quotes by content, author, movie title & film type"
        sc.searchResultsUpdater = self
        sc.searchBar.sizeToFit()
        return sc
    }()
    
    let resultsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = ""
        label.textColor = .black
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsCountLabel.alpha = 0
        self.collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        request.testDevices = [ "d61a2f834f47d41f5beceaa02715e221" ]
        interstitial = createAndLoadInterstitial()
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: cellID)
        QuoteService.shared.getQuotes {}
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Discover"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = .white
        view.addSubview(resultsCountLabel)
        view.addSubview(collectionView)
        displayConstraints()
    }
    
    private func displayConstraints() {
        NSLayoutConstraint.activate([
            resultsCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            resultsCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            resultsCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: resultsCountLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Private instance methods
    
    private func searchBarIsEmpty() -> Bool {
        // return true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredQuotes = QuoteService.shared.quotes.filter({ (quote: Quote) -> Bool in
            let text = searchText.lowercased()
            if quote.content.lowercased().contains(text) { return true }
            if quote.author.lowercased().contains(text) { return true }
            if quote.film.title.lowercased().contains(text) { return true }
            if quote.film.type.title.lowercased().contains(text) { return true }
            return false
        })
        
//        state = filteredCategories.isEmpty && !searchBarIsEmpty() ? .noData : .loaded
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    @objc func viewTapped() {

    }
    

}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredQuotes.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        let quote: Quote
        if isFiltering() {
            quote = filteredQuotes[indexPath.row]
            cell.isBookmarked = bookmarkManager.allBookmarks.contains(quote) ? true: false
            cell.quote = quote
            cell.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.6549019608, blue: 0.7529411765, alpha: 1)
            cell.delegate = self
            return cell
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = EditQuoteViewController()
        destinationController.quote = filteredQuotes[indexPath.row]
        present(UINavigationController(rootViewController: destinationController), animated: true, completion: nil)
    }

}

extension DiscoverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension DiscoverViewController: QuoteCellDelegate {
    
    func infoButtonPressed(imdb_id: String) {
        Environment.InfoButtonClickedCount += 1
        let quoteDetailView = QuoteDetailController()
        OMDBService.instance.getFilmInfo(with: imdb_id) {
            quoteDetailView.film = OMDBService.instance.filmOMDB
        }
        destinationController = UINavigationController(rootViewController: quoteDetailView)
        if Environment.InfoButtonClickedCount % 5 == 0 {
            if interstitial.isReady {
                print("shwoing ad")
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }
        } else {
            present(destinationController!, animated: true, completion: nil)
        }
    }
    
}

extension DiscoverViewController: GADInterstitialDelegate {
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Environment.InterstitialAd)
        interstitial.delegate = self
        interstitial.load(TestDeviceRequest)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        present(destinationController!, animated: true, completion: nil)
    }
    
}
