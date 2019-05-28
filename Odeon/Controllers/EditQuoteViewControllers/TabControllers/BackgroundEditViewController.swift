//
//  BackgroundEditViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 2/9/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class BackgroundEditViewController: UIViewController {
    
    weak var editQuoteController: EditQuoteViewController?
    
    let selectImageBtn: SelectBackgroundButton = {
        let btn = SelectBackgroundButton(type: .system)
        btn.setImage(UIImage(named: "unsplashSearch"), for: .normal)
        return btn
    }()
    
    let selectColorBtn: SelectBackgroundButton = {
        let btn = SelectBackgroundButton(type: .system)
        btn.setImage(UIImage(named: "colorFill"), for: .normal)
        return btn
    }()

    let selectFromPhotosBtn: SelectBackgroundButton = {
        let btn = SelectBackgroundButton(type: .system)
        btn.setImage(UIImage(named: "photoLibrary"), for: .normal)
        return btn
    }()
    
    let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 20
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(selectColorBtn)
        buttonStackView.addArrangedSubview(selectImageBtn)
        buttonStackView.addArrangedSubview(selectFromPhotosBtn)
        selectColorBtn.addTarget(self, action: #selector(colorSelect), for: .touchUpInside)
        selectImageBtn.addTarget(self, action: #selector(imageSelect), for: .touchUpInside)
        selectFromPhotosBtn.addTarget(self, action: #selector(fromPhotosSelect), for: .touchUpInside)
        displayConstraints()
    }
    
    fileprivate func displayConstraints() {
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    // actionbuuttons
    @objc func colorSelect() {
        let backgroundColorChoserView = BackgroundColorViewController()
        backgroundColorChoserView.delegate = self
        let destination = UINavigationController(rootViewController: backgroundColorChoserView)
        present(destination, animated: true, completion: nil)
    }
    
    @objc func imageSelect() {
        let USConfig = UnsplashPhotoPickerConfiguration(accessKey: Environment.USAccessKey, secretKey: Environment.USSecretKey)
        let desitnation = UnsplashPhotoPicker(configuration: USConfig)
        desitnation.photoPickerDelegate = self
        present(desitnation, animated: true, completion: nil)
    }

    @objc func fromPhotosSelect() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

}

extension BackgroundEditViewController: UnsplashPhotoPickerDelegate {
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        guard let urlString = photos.first?.urls[.regular] else { return }
        editQuoteController?.quoteView.quoteBackgroundImage.downloadImage(from: urlString.absoluteString,loadingIndicator: editQuoteController?.quoteView.loadingIndicator, completion: editQuoteController?.quoteView.setupBackgroundImage)
    }

    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        return
    }


}


extension BackgroundEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        editQuoteController?.quoteView.quoteBackgroundImage.image = image
        editQuoteController?.quoteView.setupBackgroundImage()
        dismiss(animated: true, completion: nil)
    }
}

extension BackgroundEditViewController: BackgroundColorDelegate {
    func didSelectBackgroundColor(color: UIColor) {
        editQuoteController?.quoteBkgdColor = color
        editQuoteController?.updateQuoteBackground()
    }
}
