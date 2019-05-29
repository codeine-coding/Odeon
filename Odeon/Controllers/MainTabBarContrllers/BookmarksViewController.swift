//
//  BookmarksViewController.swift
//  Odeon
//
//  Created by Allen Whearry on 4/11/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BookmarksViewController: QuoteListViewController {

    var bookmarkManager = BookmarkedQuoteManager()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.reloadData()
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: cellID)
    }

    override func setupView() {
        navigationItem.title = "Bookmarks"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        displayConstraints()
    }

    override func displayConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

    //
    // MARK - CollectionView Methods
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkManager.bookmarkQuoteCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        cell.quoteView.quote = bookmarkManager.allBookmarks[indexPath.row]
        cell.isBookmarked = true
        cell.delegate = self
        cell.bookmarkController = self
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.3607843137, blue: 0.2509803922, alpha: 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = EditQuoteViewController()
        destinationController.quoteView.quote = bookmarkManager.allBookmarks[indexPath.row]
        present(UINavigationController(rootViewController: destinationController), animated: true, completion: nil)
    }
}
