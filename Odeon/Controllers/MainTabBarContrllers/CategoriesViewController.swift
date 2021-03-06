//
//  CategoriesViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/20/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CategoriesViewController: UIViewController, NoDataViewDisplayer, LoadingViewRequired {
    
    let cellID = "CellID"

    var categories: [Category] = [] {
        didSet { self.collectionView.reloadData() }
    }

    var filteredCategories: [Category] = [] {
        didSet { self.collectionView.reloadData() }
    }
    
    var categoryDetailController: CategoryDetailViewController!

    var cellFrame: CGRect!
    var cellPosition: CGPoint!

    lazy var noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .gray
        view.hidesWhenStopped = true
        return view
    }()

    lazy var bannerView: GADBannerView = {
        let view = GADBannerView(adSize: kGADAdSizeLargeBanner)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adUnitID = Environment.categoryBannerAd
        view.rootViewController = self
        let request = GADRequest()
        request.testDevices = [ "d61a2f834f47d41f5beceaa02715e221" ]
        view.load(request)
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
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search Categories"
        sc.searchBar.accessibilityLabel = "Search"
        sc.searchResultsUpdater = self
        sc.searchBar.sizeToFit()
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: cellID)
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        collectionView.reloadData()
        searchController.searchBar.isHidden = false
        searchController.isActive = false
    }
    
    private func setupView() {
        navigationItem.title = "Categories"
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationController?.navigationBar.accessibilityIdentifier = "Odeon.Categories"
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(bannerView)
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadCategories()
        displayConstraints()
    }
    
    private func displayConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 75),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 75),
            ])
    }

    private func loadCategories() {
        CategoryService.shared.getCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.handle(result: categories)
            case .failure(let error):
                self?.handle(error: error)
            }
        }
    }

    private func handle(result: [Category]) {
        self.categories = result
        if self.categories.isEmpty {
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
    
    // MARK: - Private instance methods
    
    private func searchBarIsEmpty() -> Bool {
        // return true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCategories = categories.filter({ (category: Category) -> Bool in
            return category.name.lowercased().contains(searchText.lowercased())
        })


        if filteredCategories.isEmpty && !searchBarIsEmpty() {
            loadingIndicator.stopAnimating()
            showNoDataView(with: .noResults)
        } else {
            hideEmptyView()
        }
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCategories.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CategoryCell
        let category: Category
        if isFiltering() {
            category = filteredCategories[indexPath.row]
        } else {
            category = categories[indexPath.row]
        }
        cell.category = category
        cell.accessibilityIdentifier = category.name
        cell.accessibilityLabel = "Cell\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width)
        return CGSize(width: cellWidth, height: cellWidth * 0.50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 108, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category: Category
        if isFiltering() {
            category = filteredCategories[indexPath.row]
        } else {
            category = categories[indexPath.row]
        }
        cellFrame = collectionView.cellForItem(at: indexPath)?.frame
        let offsetY = collectionView.contentOffset.y
        let cellY = cellFrame.origin.y
        let positionInScreen = cellY - offsetY
        let cellX = cellFrame.origin.x + 8
        cellPosition = CGPoint(x: cellX, y: positionInScreen)
        let destinationController = CategoryDetailViewController()
        searchController.searchBar.isHidden = true
        searchController.isActive = false
        self.categoryDetailController = destinationController
        destinationController.category = category
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
}

extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension CategoriesViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        switch operation {
        case .push:
            return CategorySelectionPushTransition(cellFrame: cellFrame, cellPosition: cellPosition, toViewOriginFrame: self.view.frame)
        case .pop:
            return CategoryDetailPopTransition(cellFrame: cellFrame, cellPosition: cellPosition, fromViewOriginFrame: categoryDetailController.view.frame)
        default:
            return nil
        }
    }
}
