//
//  QuoteDetailController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class QuoteDetailController: UIViewController {
    
    var film: FilmOMDB? {
        didSet {
            guard
                let title = film?.Title,
                let posterURL = film?.Poster,
                let plot = film?.Plot,
                let rated = film?.Rated,
                let releasedOn = film?.Released,
                let imdbRating = film?.imdbRating
            else { return }
            self.posterImage.downloadImage(from: posterURL)
            self.posterBackgroundImage.downloadImage(from: posterURL)
            self.titleLabel.text = title
            self.releasedLabel.text = "Released: \(releasedOn)"
            self.ratedLabel.text = "Rated: \(rated)"
            self.imdbScoreLabel.text = "Score(IMDB): \(imdbRating)/10"
            self.plotLabel.text = plot
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    let releasedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    let ratedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    let imdbScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let posterBackgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "")
        return iv
    }()
    
    let bluredView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let posterImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "")
        return iv
    }()
    
    let plotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let backBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = backBarButton
        view.backgroundColor = .white
        view.addSubview(posterBackgroundImage)
        view.addSubview(bluredView)
        view.addSubview(posterImage)
        view.addSubview(titleLabel)
        view.addSubview(releasedLabel)
        view.addSubview(ratedLabel)
        view.addSubview(imdbScoreLabel)
        view.addSubview(plotLabel)
        displayConstraints()
    }
    
    func displayConstraints() {
        NSLayoutConstraint.activate([
            posterBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            posterBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            posterBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            posterBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bluredView.topAnchor.constraint(equalTo: view.topAnchor),
            bluredView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bluredView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bluredView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 8),

            releasedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            releasedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            releasedLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 8),

            ratedLabel.topAnchor.constraint(equalTo: releasedLabel.bottomAnchor, constant: 5),
            ratedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            ratedLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 8),

            imdbScoreLabel.topAnchor.constraint(equalTo: ratedLabel.bottomAnchor, constant: 5),
            imdbScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            imdbScoreLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 8),
            
            posterImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            posterImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            posterImage.widthAnchor.constraint(equalToConstant: 101),
            posterImage.heightAnchor.constraint(equalToConstant: 150),
            
            plotLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 16),
            plotLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            plotLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
    }
    
    @objc func doneTapped() {
        dismiss(animated: true, completion: nil)
    }

}
