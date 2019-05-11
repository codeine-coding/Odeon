//
//  EditQuoteViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/22/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit
//import QuoteInfoKit

class EditQuoteViewController: UIViewController {
    var debug = false
    var quoteBkgdColor: UIColor?
    var imageInitialOrigin = CGPoint()
    var squareImageConstraints = [NSLayoutConstraint]()
    var portraitImageConstraints = [NSLayoutConstraint]()
    var landscapeImageConstraints = [NSLayoutConstraint]()
    
    var quote: Quote? {
        didSet {
            guard let content = quote?.content,
                let author = quote?.author,
                let filmTitle = quote?.film.title,
                let entertainmentType = quote?.film.type.title
            else { return }
            
            if debug {
                self.quoteContentLabel.text = "Lorem ipsum dolor fames eu, amet elit."
                view.layoutIfNeeded()
                self.quoteContentLabel.updateTextFont()
                self.quoteAuthorLabel.text = ""
                self.quoteFilmTitleLabel.text = ""
            } else {
                self.quoteContentLabel.text = "\(content)"
                view.layoutIfNeeded()
                self.quoteContentLabel.updateTextFont()
                self.quoteAuthorLabel.text = "- \(author)"
                self.quoteFilmTitleLabel.text = "\(filmTitle) (\(entertainmentType))"
            }
            
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
//        iv.image = UIImage(named: "")
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let editView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    lazy var colorChooserView: ColorChooserView = {
        let view = ColorChooserView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    
    let editBarController = EditViewTabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(editView)
        print(editView.frame.origin)
        print(editView.safeAreaLayoutGuide.layoutFrame.origin)
        editView.addSubview(quoteBackgroundImage)
        editView.addSubview(quoteContentLabel)
        editView.addSubview(quoteAuthorLabel)
        editView.addSubview(quoteFilmTitleLabel)
        imageInitialOrigin = quoteBackgroundImage.frame.origin

//        view.addSubview(colorChooserView)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelEdit))
        navigationItem.leftBarButtonItem = cancelButton
        let igBtn = UIBarButtonItem(title: "Instagram", style: .plain, target: self, action: #selector(ShareToIg))
        navigationItem.rightBarButtonItem = igBtn
        
        
        editBarController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(editBarController)
        view.addSubview(editBarController.view)
        editBarController.didMove(toParent: self)
        editBarController.backgroundEdit.editQuoteController = self
        editBarController.fontEdit.editQuoteController = self
        
        displayConstraints()
        updateQuoteBackground()
    }
    
    private func displayConstraints() {
        guard let editBarView = editBarController.view else { fatalError() }
        NSLayoutConstraint.activate([
            editView.widthAnchor.constraint(equalToConstant: view.frame.width),
            editView.heightAnchor.constraint(equalToConstant: view.frame.width),
            editView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            quoteFilmTitleLabel.bottomAnchor.constraint(equalTo: editView.bottomAnchor, constant: -8),
            quoteFilmTitleLabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 8),
            quoteFilmTitleLabel.trailingAnchor.constraint(equalTo: editView.trailingAnchor, constant: -8),
            
            quoteAuthorLabel.bottomAnchor.constraint(equalTo: quoteFilmTitleLabel.topAnchor, constant: -8),
            quoteAuthorLabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 8),
            quoteAuthorLabel.trailingAnchor.constraint(equalTo: editView.trailingAnchor, constant: -8),
            
            quoteContentLabel.topAnchor.constraint(equalTo: editView.topAnchor, constant: 52),
            quoteContentLabel.bottomAnchor.constraint(equalTo: quoteAuthorLabel.topAnchor, constant: -16),
            quoteContentLabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 16),
            quoteContentLabel.trailingAnchor.constraint(equalTo: editView.trailingAnchor, constant: -16),
            quoteContentLabel.heightAnchor.constraint(equalTo: quoteContentLabel.widthAnchor, multiplier: 0.74344023),

            editBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editBarView.topAnchor.constraint(equalTo: editView.bottomAnchor),
            
            ])
        view.layoutIfNeeded()
    }
    
    func updateQuoteBackground() {
        if let bgColor = quoteBkgdColor {
            if quoteBackgroundImage.image != nil {
                quoteBackgroundImage.image = UIImage(named: "")
            }
            editView.backgroundColor = bgColor
        } else {
            editView.backgroundColor = .darkGray
        }
    }
    
    func TextOpacity(alpha: CGFloat) {
        quoteContentLabel.alpha = alpha
        quoteAuthorLabel.alpha = alpha
        quoteFilmTitleLabel.alpha = alpha

    }
    
    func setupBackgroundImage() {
        setupBackgroundImageConstraints()
        setupPanGesture()
    }
    func setupBackgroundImageConstraints() {
        guard
            let imageWidth = quoteBackgroundImage.image?.size.width,
            let imageHeight = quoteBackgroundImage.image?.size.height
            else { return }

        if imageWidth > imageHeight {
            let ratio = imageWidth / imageHeight
            landscapeImageConstraints = [
                quoteBackgroundImage.topAnchor.constraint(equalTo: editView.topAnchor),
                quoteBackgroundImage.bottomAnchor.constraint(equalTo: editView.bottomAnchor),
                quoteBackgroundImage.widthAnchor.constraint(equalTo: editView.heightAnchor, multiplier: ratio),
                quoteBackgroundImage.centerXAnchor.constraint(equalTo: editView.centerXAnchor),
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
                quoteBackgroundImage.leadingAnchor.constraint(equalTo: editView.leadingAnchor),
                quoteBackgroundImage.trailingAnchor.constraint(equalTo: editView.trailingAnchor),
                quoteBackgroundImage.centerYAnchor.constraint(equalTo: editView.centerYAnchor),
                quoteBackgroundImage.heightAnchor.constraint(equalTo: editView.widthAnchor, multiplier: ratio)
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
                quoteBackgroundImage.topAnchor.constraint(equalTo: editView.topAnchor),
                quoteBackgroundImage.leadingAnchor.constraint(equalTo: editView.leadingAnchor),
                quoteBackgroundImage.trailingAnchor.constraint(equalTo: editView.trailingAnchor),
                quoteBackgroundImage.bottomAnchor.constraint(equalTo: editView.bottomAnchor),
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

    // MARK - Button Actions
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
            correctOffset(for: panView, in: editView, duration: duration)
        default:
            panView.frame.origin = imageInitialOrigin
        }

    }
    
    func correctOffset(for panView: UIView, in superView: UIView, duration: TimeInterval) {
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
//    @objc func chooseTextColortapped() {
//        opacitySlider.isHidden = false
//        colorChooserView.isHidden = false
//        textAlignmentStackView.isHidden = false
//    }
    
    @objc func cancelEdit() {
        dismiss(animated: true, completion: nil)
    }
    
//    @objc func changeOpacity(_ slider: UISlider) {
//        let alpha = CGFloat(slider.value)
//        TextOpacity(alpha: alpha)
//    }
    
    @objc func setTextAligment(_ btn: AlignmentButton) {
        quoteContentLabel.textAlignment = btn.textAlignment
    }
    
    @objc func ShareToIg() {
        let instagramURL = NSURL(string: InstagramManager.kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let image = getImageFromView()
            InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: image, instagramCaption: "My Photo", view: self.view)
            copyTextToInstagram(quote)
        } else {
            let NoIGAlert = UIAlertController(title: InstagramManager.kAlertViewTitle, message: InstagramManager.kAlertViewMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            NoIGAlert.addAction(okAction)
            present(NoIGAlert, animated: true, completion: nil)
        }
    }
    
    @objc func handleShare() {
        let image = getImageFromView()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func copyTextToInstagram(_ quote: Quote? ) {
        guard let quote = quote else { return }
        let textCaption = """
        \"\(quote.content)\"
        - \(quote.author)
        \(quote.film.title) [\(quote.film.type.title)]
        .
        .
        .
        .
        ——————————————————
        #motivationalquotes #motivation #motivationquotes #life #lifequotes #photography #love #photooftheday #beautiful #behappy #succes #succesquotes #inspiration #inspirationalquotes #inspiringquotes #deep #deepquotes #moviequotes #successfulmindset #successday #successhabits #successmindset #successful #successstories #successmotivation #successfulliving
        """
        UIPasteboard.general.string = textCaption
    }
    
    func getImageFromView() -> UIImage {
        print("Getting Image")
        UIGraphicsBeginImageContextWithOptions(editView.frame.size, true, 0.0)
        editView.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

extension EditQuoteViewController: ColorChooserDelegate {
    func didSelectTextColor(color: UIColor) {
        quoteContentLabel.textColor = color
        quoteAuthorLabel.textColor = color
        quoteFilmTitleLabel.textColor = color
    }
}
