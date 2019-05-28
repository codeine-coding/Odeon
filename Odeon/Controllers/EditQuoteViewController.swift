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
    var quoteBkgdColor: UIColor?

    let quoteView = QuoteView()

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
        editView.addSubview(quoteView)

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

            quoteView.topAnchor.constraint(equalTo: editView.topAnchor),
            quoteView.bottomAnchor.constraint(equalTo: editView.bottomAnchor),
            quoteView.leadingAnchor.constraint(equalTo: editView.leadingAnchor),
            quoteView.trailingAnchor.constraint(equalTo: editView.trailingAnchor),

            editBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editBarView.topAnchor.constraint(equalTo: editView.bottomAnchor),
            
            ])
        view.layoutIfNeeded()
    }
    
    func updateQuoteBackground() {
        if let bgColor = quoteBkgdColor {
            if quoteView.quoteBackgroundImage.image != nil {
                quoteView.quoteBackgroundImage.image = UIImage(named: "")
            }
            editView.backgroundColor = bgColor
        } else {
            editView.backgroundColor = .darkGray
        }
    }
    
    func TextOpacity(alpha: CGFloat) {
        quoteView.quoteContentLabel.alpha = alpha
        quoteView.quoteAuthorLabel.alpha = alpha
        quoteView.quoteFilmTitleLabel.alpha = alpha

    }

    @objc func cancelEdit() {
        dismiss(animated: true, completion: nil)
    }

    
    @objc func setTextAligment(_ btn: AlignmentButton) {
        quoteView.quoteContentLabel.textAlignment = btn.textAlignment
    }
    
    @objc func ShareToIg() {
        let instagramURL = NSURL(string: InstagramManager.kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let image = getImageFromView()
            InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: image, instagramCaption: "My Photo", view: self.view)
            copyTextToInstagram(quoteView.quote)
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
        quoteView.quoteContentLabel.textColor = color
        quoteView.quoteAuthorLabel.textColor = color
        quoteView.quoteFilmTitleLabel.textColor = color
    }
}
