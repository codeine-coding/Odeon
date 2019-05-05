//
//  BackgroundEditViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 2/9/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class BackgroundEditViewController: UIViewController {
    
    var editQuoteController: EditQuoteViewController?
    
    let selectImageBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .primary
        btn.setTitle("Select Background Image", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: Font.Animosa.Bold, size: 18)
        btn.titleLabel?.numberOfLines = 0
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        btn.layer.cornerRadius = 16
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let selectColorBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .primary
        btn.setTitle("Select Background Color", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: Font.Animosa.Bold, size: 18)
        btn.titleLabel?.numberOfLines = 0
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        btn.layer.cornerRadius = 16
        btn.layer.masksToBounds = true
        return btn
    }()

    let selectFromPhotosBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .primary
        btn.setTitle("Select From Photos", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: Font.Animosa.Bold, size: 18)
        btn.titleLabel?.numberOfLines = 0
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        btn.layer.cornerRadius = 16
        btn.layer.masksToBounds = true
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
            buttonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
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
        let backgroundImageChooseVC = StockImageSearchViewController()
        backgroundImageChooseVC.editQuoteViewController = editQuoteController
        let destination = UINavigationController(rootViewController: backgroundImageChooseVC)
        present(destination, animated: true, completion: nil)
    }

    @objc func fromPhotosSelect() {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

}

extension BackgroundEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        editQuoteController?.quoteBackgroundImage.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension BackgroundEditViewController: BackgroundColorDelegate {
    func didSelectBackgroundColor(color: UIColor) {
        editQuoteController?.quoteBkgdColor = color
        editQuoteController?.updateQuoteBackground()
    }
}

extension BackgroundEditViewController: StockImageDelegate {
    func didSelectBackgroundImage(imageView: UIImageView) {
        editQuoteController?.quoteBackgroundImage.image = imageView.image
    }
}
