//
//  StockImageSearchViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/23/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

protocol StockImageDelegate {
    func didSelectBackgroundImage(imageView: UIImageView)
}

class StockImageSearchViewController: UIViewController {
    
    var editQuoteViewController: EditQuoteViewController?
    
    let cellID = "UnsplashImageCell"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let cellWidth = (view.frame.width - 4) / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UnsplashImageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search free images from Unsplash"
        sc.searchBar.delegate = self
        sc.searchBar.sizeToFit()
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        UnsplashService.instance.getUnsplashPhotos {
            self.collectionView.reloadData()
        }
        setupView()
    }
    
    fileprivate func setupView() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        setupNavigationBar()
        displayConstraints()
    }

    fileprivate func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelEdit))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    fileprivate func displayConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK - Button Actions
    @objc fileprivate func cancelEdit() {
        dismiss(animated: true, completion: nil)
    }

}

extension StockImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchImage(searchController.searchBar.text!)
    }

    fileprivate func searchImage(_ searchText: String) {
        let query = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        do {
            try UnsplashService.instance.searchPhotos(query: query) {
                self.collectionView.reloadData()
            }
        } catch SearchError.ZeroSearch {
            print("no images found")
        } catch {
            print("something else went wrong")
        }
    }
}

extension StockImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UnsplashService.instance.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UnsplashImageCell
        
        let photo = UnsplashService.instance.photos[indexPath.row]
        cell.thumbnail.downloadImage(from: photo.urls.thumb)
        cell.userLabel.text = photo.user.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = UnsplashService.instance.photos[indexPath.row]
        editQuoteViewController?.quoteBackgroundImage.downloadImage(from: photo.urls.regular)
        dismiss(animated: true, completion: nil)
        
    }
}
