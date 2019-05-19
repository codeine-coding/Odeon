//
//  QuoteView.swift
//  Odeon
//
//  Created by Allen Whearry on 5/19/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

class QuoteView: UIView {

    var quote: Quote? {
        didSet {
            guard let content = quote?.content,
                let author = quote?.author,
                let filmTitle = quote?.film.title,
                let entertainmentType = quote?.film.type.title
                else { return }


            self.quoteContentLabel.text = "\(content)"
            layoutIfNeeded()
            self.quoteContentLabel.updateTextFont()
            self.quoteAuthorLabel.text = "- \(author)"
            self.quoteFilmTitleLabel.text = "\(filmTitle) (\(entertainmentType))"


        }
    }

    let quoteContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: Font.Animosa.Regular, size: 15)
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    let quoteAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: Font.Animosa.Regular, size: 15)
        label.textColor = .white
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
        return label
    }()

    var quoteBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(quoteBackgroundImage)
        addSubview(quoteContentLabel)
        addSubview(quoteAuthorLabel)
        addSubview(quoteFilmTitleLabel)
        displayConstraints()
    }

    func displayConstraints() {
        NSLayoutConstraint.activate([
            quoteFilmTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            quoteFilmTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            quoteFilmTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            quoteAuthorLabel.bottomAnchor.constraint(equalTo: quoteFilmTitleLabel.topAnchor, constant: -8),
            quoteAuthorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            quoteAuthorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            quoteContentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 52),
            quoteContentLabel.bottomAnchor.constraint(equalTo: quoteAuthorLabel.topAnchor, constant: -16),
            quoteContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            quoteContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            quoteContentLabel.heightAnchor.constraint(equalTo: quoteContentLabel.widthAnchor, multiplier: 0.74344023),

            ])
    }

}
