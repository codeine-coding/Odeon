//
//  NoDataView.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/25/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

enum EmptyState {
    case noResults
    // TODO: - Implement no internet & server error
    case serverError

    var title: String {
        switch self {
        case .noResults:
            return "No Results Found"
        case .serverError:
            return "Server Errror"
        }
    }

    var message: String {
        switch self {
        case .noResults:
            return "Try another search."
        case .serverError:
            return "Oops! Something went wrong on the server"
        }
    }
}

class NoDataView: UIView {

    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont(name: Font.Animosa.Bold, size: 26)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = UIFont(name: Font.Animosa.Bold, size: 18)
        label.textAlignment = .center
        return label
    }()

    var state: EmptyState? {
        didSet{
            titleLabel.text = state?.title
            messageLabel.text = state?.message
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Views
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(messageLabel)
        displayConstraints()
    }
    
    private func displayConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])
    }

}
