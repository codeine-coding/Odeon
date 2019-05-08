//
//  HomeViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    var interstitial: GADInterstitial!
    let cellID = "CellID"
    var destinationController: UINavigationController?
    var InfoBtnClickedCount: Int = 0
    var mainColor: UIColor = #colorLiteral(red: 0.4941176471, green: 0.4078431373, blue: 0.7921568627, alpha: 1)
    var bookmarkManager = BookmarkedQuoteManager()
    let noDataView = NoDataView()
    
    var qotd: [Quote] = [] {
        didSet {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = qotd.count
        }
    }
    
    var state: State = .loading {
        didSet {
            switch state {
            case .noData:
                noDataView.isHidden = false
                collectionView.isHidden = true
                loadingIndicator.stopAnimating()
            case .loading:
                noDataView.isHidden = true
                collectionView.isHidden = true
            case .loaded:
                noDataView.isHidden = true
                collectionView.isHidden = false
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .whiteLarge
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
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
        collectionView.backgroundColor = mainColor
        collectionView.showsHorizontalScrollIndicator = false
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
        interstitial = createAndLoadInterstitial()
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: cellID)
        setupView()
    }
    
    func setupView() {
        navigationItem.title = "Quotes of The Day"
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        loadingIndicator.startAnimating()
        QuoteService.shared.getQuotesOfTheDay {
            self.qotd = QuoteService.shared.qotd
            self.state = self.qotd.isEmpty ? .noData : .loaded
        }
        displayConstraints()
    }
    
    func displayConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QuoteService.shared.qotd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        let quote = QuoteService.shared.qotd[indexPath.row]
        cell.isBookmarked = bookmarkManager.allBookmarks.contains(quote) ? true: false
        cell.delegate = self
        cell.backgroundColor = mainColor
        cell.quote = quote
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension HomeViewController: QuoteCellDelegate {
    
    func infoButtonPressed(imdb_id: String) {
        InfoBtnClickedCount += 1
        let quoteDetailView = QuoteDetailController()
        OMDBService.instance.getFilmInfo(with: imdb_id) {
            quoteDetailView.film = OMDBService.instance.filmOMDB
        }
        destinationController = UINavigationController(rootViewController: quoteDetailView)
        if InfoBtnClickedCount % 5 == 0 {
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

extension HomeViewController: HasInterstitalAd {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        present(destinationController!, animated: true, completion: nil)
    }

}
