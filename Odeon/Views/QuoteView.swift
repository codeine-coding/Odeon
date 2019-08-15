//
//  QuoteView.swift
//  Odeon
//
//  Created by Allen Whearry on 5/19/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import UIKit

// MARK: Quote Delegate
protocol QuoteViewDelegate: class {
    func setupBackgroundImage()
}

class QuoteView: UIView {
    // MARK: - Properties
    weak var delegate: QuoteViewDelegate?
    var squareImageConstraints = [NSLayoutConstraint]()
    var portraitImageConstraints = [NSLayoutConstraint]()
    var landscapeImageConstraints = [NSLayoutConstraint]()
    
    var imageInitialOrigin = CGPoint()
    
    
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
    
    let loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .whiteLarge
        view.backgroundColor = #colorLiteral(red: 0.2379976213, green: 0.2367053628, blue: 0.2389970124, alpha: 0.8296493902)
        view.hidesWhenStopped = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    // MARK: - VC Setup
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
        addSubview(loadingIndicator)
        imageInitialOrigin = quoteBackgroundImage.frame.origin
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
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 150),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 150),
            
            ])
    }
    
    func setupBackgroundImage() {
        setupBackgroundImageConstraints()
        setupPanGesture()
        setupPinchGesture()
    }
    
    func setupBackgroundImageConstraints() {
        guard
            let imageWidth = quoteBackgroundImage.image?.size.width,
            let imageHeight = quoteBackgroundImage.image?.size.height
            else { return }
        
        if imageWidth > imageHeight {
            let ratio = imageWidth / imageHeight
            landscapeImageConstraints = [
                quoteBackgroundImage.topAnchor.constraint(equalTo: topAnchor),
                quoteBackgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
                quoteBackgroundImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio),
                quoteBackgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            ]
            if !squareImageConstraints.isEmpty{
                if squareImageConstraints[0].isActive {
                    NSLayoutConstraint.deactivate(squareImageConstraints)
                }
            }
            if !portraitImageConstraints.isEmpty {
                if portraitImageConstraints[0].isActive {
                    NSLayoutConstraint.deactivate(portraitImageConstraints)
                }
            }
            NSLayoutConstraint.activate(landscapeImageConstraints)
        } else if imageWidth < imageHeight  {
            let ratio = imageHeight / imageWidth
            portraitImageConstraints = [
                quoteBackgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                quoteBackgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                quoteBackgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                quoteBackgroundImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio)
            ]
            if !squareImageConstraints.isEmpty{
                if squareImageConstraints[0].isActive {
                    NSLayoutConstraint.deactivate(squareImageConstraints)
                }
            }
            if !landscapeImageConstraints.isEmpty {
                if landscapeImageConstraints[0].isActive {
                    NSLayoutConstraint.deactivate(landscapeImageConstraints)
                }
            }
            NSLayoutConstraint.activate(portraitImageConstraints)
        } else {
            squareImageConstraints = [
                quoteBackgroundImage.topAnchor.constraint(equalTo: topAnchor),
                quoteBackgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                quoteBackgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                quoteBackgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
            if !portraitImageConstraints.isEmpty{
                if portraitImageConstraints[0].isActive {
                    NSLayoutConstraint.deactivate(portraitImageConstraints)
                }
            }
            if !landscapeImageConstraints.isEmpty {
                if landscapeImageConstraints[0].isActive {
                    NSLayoutConstraint.deactivate(landscapeImageConstraints)
                }
            }
            NSLayoutConstraint.activate(squareImageConstraints)
        }
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panImageView(_:)))
        quoteBackgroundImage.addGestureRecognizer(panGesture)
    }
    
    func setupPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchImageView(_:)))
        quoteBackgroundImage.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Button Actions
    @objc func panImageView(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let panView = gestureRecognizer.view else { return }
        
        let translation = gestureRecognizer.translation(in: panView.superview)
        switch gestureRecognizer.state {
        case .began, .changed:
            panView.center = CGPoint(
                x: panView.center.x + translation.x,
                y: panView.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: panView.superview!)
        case .ended:
            let duration: TimeInterval = 0.2
            correctOffset(for: panView, in: self, duration: duration)
        default:
            panView.frame.origin = imageInitialOrigin
        }
        
    }
    
    @objc func pinchImageView(_ gesturRecoginzer: UIPinchGestureRecognizer) {
        guard let pinchView = gesturRecoginzer.view else { return }
        
        switch gesturRecoginzer.state {
        case .began, .changed:
            pinchView.transform = pinchView.transform.scaledBy(x: gesturRecoginzer.scale, y: gesturRecoginzer.scale)
            gesturRecoginzer.scale = 1.0
        case .ended:
            let duration = 0.2
            correctOffset(for: pinchView, in: self, duration: duration)
        default:
            break
        }
        
    }
    
    // MARK: Pan & Pinch offset funcs
    func correctOffset(for panView: UIView, in superView: UIView, duration: TimeInterval) {
        checkAllEdgesWithinFrame(of: panView, in: superView, duration: duration)
        checkOriginPointsOffset(of: panView, in: superView, duration: duration)
        checkOriginMaxPointsOffset(of: panView, in: superView, duration: duration)
    }
    
    func checkOriginPointsOffset(of panView: UIView, in superView: UIView, duration: TimeInterval) {
        let superViewframe = superView.safeAreaLayoutGuide.layoutFrame
        if panView.frame.origin.x > superViewframe.origin.x && panView.frame.origin.y > superViewframe.origin.y{
            UIView.animate(withDuration: duration) {
                panView.frame.origin = CGPoint(x: superViewframe.origin.x, y: superViewframe.origin.y)
            }
            
        } else if panView.frame.origin.x > superViewframe.origin.x {
            UIView.animate(withDuration: duration) {
                panView.frame.origin.x = superViewframe.origin.x
            }
        } else if panView.frame.origin.y > superViewframe.origin.y{
            UIView.animate(withDuration: duration) {
                panView.frame.origin.y = superViewframe.origin.y
            }
        }
    }
    
    func checkOriginMaxPointsOffset(of panView: UIView, in superView: UIView, duration: TimeInterval) {
        let panViewWidth = panView.frame.width
        let panViewHeight = panView.frame.height
        let superViewframe = superView.safeAreaLayoutGuide.layoutFrame
        if panView.frame.maxX < superViewframe.maxX && panView.frame.maxY < superViewframe.maxY {
            let x = superViewframe.maxX - panViewWidth
            let y = superViewframe.maxY - panViewHeight
            UIView.animate(withDuration: duration) {
                panView.frame.origin = CGPoint(x: x, y: y)
            }
        } else if panView.frame.maxX < superViewframe.maxX {
            UIView.animate(withDuration: duration) {
                panView.frame.origin.x = superViewframe.maxX - panViewWidth
            }
        } else if panView.frame.maxY < superViewframe.maxY {
            UIView.animate(withDuration: duration) {
                panView.frame.origin.y = superViewframe.maxY - panViewHeight
            }
        }
    }
    
    
    func checkAllEdgesWithinFrame(of view: UIView, in superView: UIView, duration: TimeInterval) {
        if view.frame < superView.frame {
            UIView.animate(withDuration: duration) {
                view.transform = .identity
            }
        }
    }
    
}

// MARK: - Extensions
private extension UIView {
    var isPortrait: Bool {
        return self.frame.width < self.frame.height
    }
    
    var ratio: CGFloat {
        get {
            if self.isPortrait {
                return self.frame.width / self.frame.height
            } else {
                return self.frame.height / self.frame.width
            }
        }
    }
}

private extension CGRect {
    static func < (left: CGRect, right: CGRect) -> Bool {
        if left.height < right.height {
            return true
        } else if left.width < right.width {
            return true
        } else {
            return false
        }
    }
}
