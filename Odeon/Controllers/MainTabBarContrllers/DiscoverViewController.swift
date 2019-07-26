//
//  DiscoverViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/27/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DiscoverViewController: QuoteListViewController, NoDataViewDisplayer {
    
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

    lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        sc.searchBar.accessibilityLabel = "Search"
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
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: cellID)
        loadQutoes()
    }
    
    override func setupView() {
        navigationItem.title = "Discover"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = .white
        view.addSubview(resultsCountLabel)
        view.addSubview(collectionView)
        super.setupView()
    }
    
    override func displayConstraints() {
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

    private func loadQutoes() {
        QuoteService.shared.getQuotes { [weak self] (result) in
            switch result {
            case (.success(let quotes)):
                self?.handle(result: quotes)
            case (.failure(let error)):
                self?.handle(error: error)
            }
        }
    }

    private func handle(result: [Quote]) {
        self.quotes = result
        if self.quotes.isEmpty {
            self.showNoDataView(with: .noResults)
        }
    }

    private func handle(error: Error) {
        switch error {
        case NetworkError.serverError:
            self.serverError()
        default:
            print(error.localizedDescription)
        }
    }

    private func serverError() {
        self.showNoDataView(with: .serverError)
    }

//    private func showNoDataView(with state: EmptyState) {
//        noDataView.state = state
//
//        guard noDataView.superview == nil else { return }
//
//        view.addSubview(noDataView)
//
//        NSLayoutConstraint.activate([
//            noDataView.topAnchor.constraint(equalTo: view.topAnchor),
//            noDataView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            noDataView.rightAnchor.constraint(equalTo: view.rightAnchor)
//            ])
//    }
//
//    private func hidesEmptyView() {
//        noDataView.removeFromSuperview()
//    }
    
    // MARK: - Private instance methods
    
    private func searchBarIsEmpty() -> Bool {
        // return true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredQuotes = quotes.filter({ (quote: Quote) -> Bool in
            let text = searchText.lowercased()
            if quote.content.lowercased().contains(text) { return true }
            if quote.author.lowercased().contains(text) { return true }
            if quote.film.title.lowercased().contains(text) { return true }
            if quote.film.type.title.lowercased().contains(text) { return true }
            return false
        })

        if filteredQuotes.isEmpty && !searchBarIsEmpty() {
            showNoDataView(with: .noResults)
        } else {
            hideEmptyView()
        }
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    @objc func viewTapped() {

    }

    //
    // MARK - CollectionView Methods
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredQuotes.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        let quote: Quote
        if isFiltering() {
            quote = filteredQuotes[indexPath.row]
            cell.isBookmarked = BookmarkedQuoteManager.shared.allBookmarks.contains(quote) ? true: false
            cell.quoteView.quote = quote
            cell.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.6549019608, blue: 0.7529411765, alpha: 1)
            cell.delegate = self
            return cell
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = EditQuoteViewController()
        destinationController.quoteView.quote = filteredQuotes[indexPath.row]
        present(UINavigationController(rootViewController: destinationController), animated: true, completion: nil)
    }

}

extension DiscoverViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

