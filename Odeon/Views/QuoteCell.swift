//
//  QuoteCell.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
//import QuoteInfoKit

protocol QuoteCellDelegate {
    func infoButtonPressed(imdb_id: String)
}

class QuoteCell: BaseCollectionViewCell {
    
    //
    // MARK - Properties
    //
    
    var delegate: QuoteCellDelegate?
    var bookmarkController: BookmarksViewController?
    var bookmarkManager = BookmarkedQuoteManager()
    
    //
    // MARK - Property Observers
    //
    
    var quote: Quote? {
        didSet {
            guard let content = quote?.content, let author = quote?.author, let filmTitle = quote?.film.title, let entertainmentType = quote?.film.type.title else { return }
            self.quoteContentLabel.text = "\(content)"
            layoutIfNeeded()
            self.quoteContentLabel.updateTextFont()
            self.quoteAuthorLabel.text = "- \(author)"
            self.quoteFilmTitleLabel.text = "\(filmTitle) (\(entertainmentType))"
        }
    }
    
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
    
    let quoteContentLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = ""
        let customFont = UIFont(name: Font.Animosa.Regular, size: 20)
        view.font = customFont
        view.textColor = .white
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.textAlignment = .center
        return view
    }()
    let quoteAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: Font.Animosa.Regular, size: 15)
        label.textColor = .white
        label.sizeToFit()
        label.textAlignment = .right
        return label
    }()
    
    let quoteFilmTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: Font.Animosa.Regular, size: 15)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        return label
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
        view.addSubview(quoteContentLabel)
        view.addSubview(quoteAuthorLabel)
        view.addSubview(quoteFilmTitleLabel)
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
            
            bookmarkButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            bookmarkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bookmarkButton.heightAnchor.constraint(equalTo: infoButton.heightAnchor),
            
            infoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            infoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            quoteFilmTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            quoteFilmTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            quoteFilmTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            quoteAuthorLabel.bottomAnchor.constraint(equalTo: quoteFilmTitleLabel.topAnchor, constant: -8),
            quoteAuthorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            quoteAuthorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            quoteContentLabel.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 16),
            quoteContentLabel.bottomAnchor.constraint(equalTo: quoteAuthorLabel.topAnchor, constant: -16),
            quoteContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quoteContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            quoteContentLabel.heightAnchor.constraint(equalTo: quoteContentLabel.widthAnchor, multiplier: 0.74344023)
            
            ])
        layoutIfNeeded()
    }
    
    //
    // MARK - Action Functions
    //
    
    @objc func didTapBookmarkButton() {
        guard let quote = quote else { return }
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
        guard let imdb_id = quote?.film.imdb_id else { return }
        delegate?.infoButtonPressed(imdb_id: imdb_id)
    }
    
}
