//
//  BookmarksViewController.swift
//  Odeon
//
//  Created by Allen Whearry on 4/11/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController {

    let cellID = "CellID"
    var destinationController: UINavigationController?
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
        setupView()
    }

    private func setupView() {
        navigationItem.title = "Bookmarks"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        displayConstraints()
    }

    func displayConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }

}

extension BookmarksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkManager.bookmarkQuoteCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        cell.quote = bookmarkManager.allBookmarks[indexPath.row]
        cell.isBookmarked = true
        cell.delegate = self
        cell.bookmarkController = self
        cell.contentView.backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.3607843137, blue: 0.2509803922, alpha: 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = EditQuoteViewController()
        destinationController.quote = bookmarkManager.allBookmarks[indexPath.row]
        present(UINavigationController(rootViewController: destinationController), animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 108, right: 0)
    }

}

extension BookmarksViewController: QuoteCellDelegate {

    func infoButtonPressed(imdb_id: String) {
        API.InfoButtonClickedCount += 1
        let quoteDetailView = QuoteDetailController()
        OMDBService.instance.getFilmInfo(with: imdb_id) {
            quoteDetailView.film = OMDBService.instance.filmOMDB
        }
        destinationController = UINavigationController(rootViewController: quoteDetailView)
        //        if API.InfoButtonClickedCount % 5 == 0 {
        //            if interstitial.isReady {
        //                print("shwoing ad")
        //                interstitial.present(fromRootViewController: self)
        //            } else {
        //                print("Ad wasn't ready")
        //            }
        //        } else {
        //            present(destinationController!, animated: true, completion: nil)
        //        }
        present(destinationController!, animated: true, completion: nil)
    }



}

