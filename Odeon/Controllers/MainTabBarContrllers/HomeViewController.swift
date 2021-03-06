//
//  HomeViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: QuoteListViewController, NoDataViewDisplayer, LoadingViewRequired {

    override var quotes: [Quote] {
        didSet {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.quotes.count
        }
    }

    lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .white
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .primary
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.accessibilityLabel = "QOTD Collection View"
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: cellID)
    }
    
     override func setupView() {
        navigationItem.title = "Quotes of The Day"
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadQuotes()
        displayConstraints()
    }
    
     override func displayConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 75),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 75),
        ])
    }

    private func loadQuotes() {
        QuoteService.shared.getQuotesOfTheDay { [weak self] (result) in
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
        } else {
            self.loadingIndicator.stopAnimating()
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }

    //
    // MARK - CollectionView Methods
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        let quote = quotes[indexPath.row]
        cell.isBookmarked = BookmarkedQuoteManager.shared.allBookmarks.contains(quote) ? true: false
        cell.delegate = self
        cell.backgroundColor = .primary
        cell.quoteView.quote = quote
        cell.accessibilityLabel = String(indexPath.row)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
