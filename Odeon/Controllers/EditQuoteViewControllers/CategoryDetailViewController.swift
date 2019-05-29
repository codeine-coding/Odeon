//
//  CategoryDetailViewController.swift
//  Odeon
//
//  Created by Allen Whearry on 4/11/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CategoryDetailViewController: QuoteListViewController {

    // Property Observers
    var category: Category? {
        didSet {
            guard let categoryName = category?.name else { return }
            guard let imageURl = category?.image_url else { return }
            headerView.headerImage.downloadImage(from: imageURl)
            headerView.headerTitle.text = categoryName
            guard let red = category?.red, let green = category?.green, let blue = category?.blue else { return }
            self.red = CGFloat(red)
            self.blue = CGFloat(blue)
            self.green = CGFloat(green)
        }
    }

    // Variables
    var red: CGFloat!
    var green: CGFloat!
    var blue: CGFloat!

    var headerView = CategoryHeaderView()

    // Variable Initialization Closures
    lazy var bannerView: GADBannerView = {
        let view = GADBannerView(adSize: kGADAdSizeLargeBanner)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adUnitID = Environment.categoryBannerAd
        view.rootViewController = self
//        view.load(TestDeviceRequest)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(QuoteCell.self, forCellWithReuseIdentifier: cellID)
    }

    override func setupView() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(bannerView)
        super.setupView()
    }

    override func displayConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 250),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = collectionView.contentOffset.y
        if offsetY < 0 {
            headerView.headerImage.transform = CGAffineTransform(translationX: 0, y: -offsetY/4)
        }
    }

    //
    // MARK - CollectionView Methods
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.quotes?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! QuoteCell
        let quote = category?.quotes?[indexPath.row]
        cell.quoteView.quote = quote
        cell.isBookmarked = BookmarkedQuoteManager.shared.allBookmarks.contains(quote!) ? true: false
        cell.delegate = self
        cell.contentView.backgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = EditQuoteViewController()
        destinationController.quoteView.quote = category?.quotes?[indexPath.row]
        present(UINavigationController(rootViewController: destinationController), animated: true, completion: nil)
    }

}
