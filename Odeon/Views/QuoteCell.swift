//
//  QuoteCell.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
//import QuoteInfoKit

protocol QuoteCellDelegate: class {
    func infoButtonPressed(imdb_id: String)
}

class QuoteCell: BaseCollectionViewCell {
    
    //
    // MARK - Properties
    //
    
    let quoteView = QuoteView()
    weak var delegate: QuoteCellDelegate?
    var bookmarkController: BookmarksViewController?
    
    //
    // MARK - Property Observers
    //

    var isBookmarked: Bool = false {
        didSet {
            if isBookmarked {
                bookmarkButton.tintColor = .red
            } else {
                bookmarkButton.tintColor = .white
            }
        }
    }
    
    
    //
    // MARK - UI Closures
    //
    
    lazy var overlayView: UIView = {
        let view = UIView(frame: self.frame)
        backgroundColor = .black
        return view
    }()

    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let infoButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.infoLight)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        return btn
    }()
    
    let bookmarkButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bookmark")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(image, for: UIControl.State.normal)
        btn.tintColor = .white
        return btn
    }()
    
    //
    // MARK - Setup Functions
    
    override func setupView() {
        addSubview(view)
        layer.cornerRadius = 8
        clipsToBounds = true
        view.addSubview(quoteView)
        view.addSubview(infoButton)
        view.addSubview(bookmarkButton)
        addSubview(overlayView)
        overlayView.isHidden = true
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        super.setupView()
    }
    
    override func displayConstraints() {
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: self.frame.width),
            view.heightAnchor.constraint(equalToConstant: self.frame.width),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),

            quoteView.topAnchor.constraint(equalTo: view.topAnchor),
            quoteView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            quoteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            quoteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bookmarkButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            bookmarkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bookmarkButton.heightAnchor.constraint(equalTo: infoButton.heightAnchor),
            
            infoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            ])
        layoutIfNeeded()
    }
    
    //
    // MARK - Action Functions
    //
    
    @objc func didTapBookmarkButton() {
        guard let quote = quoteView.quote else { return }
        let bookmarkManager = BookmarkedQuoteManager.shared
        if bookmarkManager.allBookmarks.contains(quote) {
            bookmarkManager.unbookmark(quote)
            isBookmarked = false
            bookmarkController?.collectionView.reloadData()
        } else {
            bookmarkManager.bookmark(quote)
            isBookmarked = true
            bookmarkController?.collectionView.reloadData()
        }
    }
    
    @objc func didTapInfoButton() {
        guard let imdb_id = quoteView.quote?.film.imdb_id else { return }
        delegate?.infoButtonPressed(imdb_id: imdb_id)
    }
    
}
