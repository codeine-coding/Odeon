//
//  FontEditViewController.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 2/9/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class FontEditViewController: UIViewController {
    
    var editQuoteController: EditQuoteViewController?
    
    let opacityLabel = SliderLabel("Opacity", frame: .zero)
    
    let opacitySlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        slider.isContinuous = true
        slider.isHidden = false
        slider.tintColor = .primary
        
        return slider
    }()
    
    lazy var opacityStackView = SliderStackView(arrangedSubviews: [self.opacityLabel, self.opacitySlider])
    
    
    let fontSizeLabel = SliderLabel("Font Size", frame: .zero)
    
    lazy var fontSizeSlider: UISlider = {
        let maxValue = self.editQuoteController?.quoteView.quoteContentLabel.font.pointSize
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = Float(maxValue!)
        slider.value = slider.maximumValue
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var fontSizeStackView = SliderStackView(arrangedSubviews: [self.fontSizeLabel, self.fontSizeSlider])
    
    let scaleLabel = SliderLabel("Scale", frame: .zero)
    
    let scaleSizeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 1
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var scaleSizeStackView = SliderStackView(arrangedSubviews: [self.scaleLabel, self.scaleSizeSlider])
    
    let yPositionLabel = SliderLabel("Y Position", frame: .zero)
    
    lazy var ySlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = Float((self.editQuoteController?.editView.frame.origin.x)!)
        slider.maximumValue = Float((self.editQuoteController?.editView.frame.height)!)
        slider.value = Float((self.editQuoteController?.quoteView.quoteContentLabel.center.y)!)
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var yPositionStackView = SliderStackView(arrangedSubviews: [self.yPositionLabel, self.ySlider])
    
    let xPositionLabel = SliderLabel("X Position", frame: .zero)
    
    lazy var xSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = Float((self.editQuoteController?.editView.frame.minX)!)
        slider.maximumValue = Float((self.editQuoteController?.editView.frame.maxX)!)
        slider.value = Float((self.editQuoteController?.quoteView.quoteContentLabel.center.x)!)
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var xPositionStackView = SliderStackView(arrangedSubviews: [self.xPositionLabel, self.xSlider])
    
    
    let shadowOpacityLabel = SliderLabel("Text Shadow Opacity", frame: .zero)
    
    lazy var shadowOpacitySlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float((self.editQuoteController?.quoteView.quoteContentLabel.layer.shadowOpacity)!)
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var shadowOpacityStackView = SliderStackView(arrangedSubviews: [self.shadowOpacityLabel, self.shadowOpacitySlider])
    
    let shadowXLabel = SliderLabel("Shadow Offset X", frame: .zero)
    
    lazy var shadowXSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -50
        slider.maximumValue = 50
        slider.value = Float((self.editQuoteController?.quoteView.quoteContentLabel.layer.shadowOffset.width)!)
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var shadowXStackView = SliderStackView(arrangedSubviews: [self.shadowXLabel, self.shadowXSlider])
    
    let shadowYLabel = SliderLabel("Shadow Offset Y", frame: .zero)
    
    lazy var shadowYSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -50
        slider.maximumValue = 50
        slider.value = Float((self.editQuoteController?.quoteView.quoteContentLabel.layer.shadowOffset.height)!)
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var shadowYStackView = SliderStackView(arrangedSubviews: [self.shadowYLabel, self.shadowYSlider])
    
    let shadowRadiusLabel = SliderLabel("Shadow Radius", frame: .zero)
    
    lazy var shadowRadiusSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 50
        slider.value = Float((self.editQuoteController?.quoteView.quoteContentLabel.layer.shadowRadius)!)
        slider.isContinuous = true
        slider.tintColor = .primary
        return slider
    }()
    
    lazy var shadowRadiusStackView = SliderStackView(arrangedSubviews: [self.shadowRadiusLabel, self.shadowRadiusSlider])
    
    let rightAlignBtn: AlignmentButton = {
        let btn = AlignmentButton(type: .system)
        btn.setImage(UIImage(named: "align-right"), for: .normal)
        btn.textAlignment = .right
        btn.tintColor = .primary
        return btn
    }()
    
    let lefAlignBtn: AlignmentButton = {
        let btn = AlignmentButton(type: .system)
        btn.setImage(UIImage(named: "align-left"), for: .normal)
        btn.textAlignment = .left
        btn.tintColor = .primary
        return btn
    }()
    
    let centerAlignBtn: AlignmentButton = {
        let btn = AlignmentButton(type: .system)
        btn.setImage(UIImage(named: "align-center"), for: .normal)
        btn.textAlignment = .center
        btn.tintColor = .primary
        return btn
    }()
    
    lazy var textAlignmentStackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.addArrangedSubview(self.lefAlignBtn)
        sv.addArrangedSubview(self.centerAlignBtn)
        sv.addArrangedSubview(self.rightAlignBtn)
        return sv
    }()
    
    lazy var mainStackView: SliderStackView = {
        var views = [textAlignmentStackView, opacityStackView,
                     fontSizeStackView, scaleSizeStackView,
                     yPositionStackView, xPositionStackView,
                     shadowOpacityStackView, shadowRadiusStackView,
                     shadowXStackView, shadowYStackView,
                     ]
        let sv = SliderStackView(arrangedSubviews: views)
        sv.distribution = .equalSpacing
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        return sv
    }()
    
    lazy var colorChooserView: ColorChooserView = {
        let view = ColorChooserView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self.editQuoteController
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        view.addSubview(colorChooserView)
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        displayConstraints()
        setupButtonTargets()
    }
    
    fileprivate func displayConstraints() {
        NSLayoutConstraint.activate([
            colorChooserView.topAnchor.constraint(equalTo: view.topAnchor),
            colorChooserView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorChooserView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorChooserView.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: colorChooserView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
        view.layoutIfNeeded()
        scrollView.contentSize = mainStackView.frame.size
    }
    
    fileprivate func setupButtonTargets() {
        rightAlignBtn.addTarget(self, action: #selector(setTextAligment(_:)), for: .touchUpInside)
        lefAlignBtn.addTarget(self, action: #selector(setTextAligment(_:)), for: .touchUpInside)
        centerAlignBtn.addTarget(self, action: #selector(setTextAligment(_:)), for: .touchUpInside)
        opacitySlider.addTarget(self, action: #selector(changeOpacity(_:)), for: .valueChanged)
        fontSizeSlider.addTarget(self, action: #selector(changeFont(_:)), for: .valueChanged)
        scaleSizeSlider.addTarget(self, action: #selector(changeScale(_:)), for: .valueChanged)
        ySlider.addTarget(self, action: #selector(changeYPosition(_:)), for: .valueChanged)
        xSlider.addTarget(self, action: #selector(changeXPosition(_:)), for: .valueChanged)
        shadowOpacitySlider.addTarget(self, action: #selector(changeShadowOpacity(_:)), for: .valueChanged)
        shadowRadiusSlider.addTarget(self, action: #selector(changeShadowRadius(_:)), for: .valueChanged)
        shadowXSlider.addTarget(self, action: #selector(changeShadowOffsetX(_:)), for: .valueChanged)
        shadowYSlider.addTarget(self, action: #selector(changeShadowOffsetY(_:)), for: .valueChanged)
    }
    
    func textOpacity(alpha: CGFloat) {
        self.editQuoteController?.quoteView.quoteContentLabel.alpha = alpha
        self.editQuoteController?.quoteView.quoteAuthorLabel.alpha = alpha
        self.editQuoteController?.quoteView.quoteFilmTitleLabel.alpha = alpha
        
    }
    
    func shadowOpacity(alpha: Float) {
        self.editQuoteController?.quoteView.quoteContentLabel.layer.shadowOpacity = alpha
        self.editQuoteController?.quoteView.quoteAuthorLabel.layer.shadowOpacity = alpha
        self.editQuoteController?.quoteView.quoteFilmTitleLabel.layer.shadowOpacity = alpha
    }
    
    func shadowRadius(radius: CGFloat) {
        self.editQuoteController?.quoteView.quoteContentLabel.layer.shadowRadius = radius
        self.editQuoteController?.quoteView.quoteAuthorLabel.layer.shadowRadius = radius
        self.editQuoteController?.quoteView.quoteFilmTitleLabel.layer.shadowRadius = radius
    }
    
    //
    //// Triggered Event Functions
    //
    @objc func setTextAligment(_ btn: AlignmentButton) {
        self.editQuoteController?.quoteView.quoteContentLabel.textAlignment = btn.textAlignment
    }
    
    @objc func changeOpacity(_ slider: UISlider) {
        let alpha = CGFloat(slider.value)
        textOpacity(alpha: alpha)
    }
    
    @objc func changeFont(_ slider: UISlider) {
        guard let contentLabelFont = self.editQuoteController?.quoteView.quoteContentLabel.font else { return }
        var expectedFont = self.editQuoteController?.quoteView.quoteContentLabel.font
        let currentFontSize = contentLabelFont.pointSize
        let fontSize = CGFloat(slider.value)
        
        expectedFont = self.editQuoteController?.quoteView.quoteContentLabel.font.withSize(contentLabelFont.pointSize - currentFontSize + fontSize )
        
        self.editQuoteController?.quoteView.quoteContentLabel.font = expectedFont
    }
    
    @objc func changeScale(_ slider: UISlider) {
        let scale = CGFloat(slider.value)
        guard let label = self.editQuoteController?.quoteView.quoteContentLabel else { return }
        
        label.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    @objc func changeYPosition(_ slider: UISlider) {
        guard let label = self.editQuoteController?.quoteView.quoteContentLabel else { return }
        let yPosition = CGFloat(slider.value)
        
        label.center.y = yPosition
    }
    
    @objc func changeXPosition(_ slider: UISlider) {
        guard let label = self.editQuoteController?.quoteView.quoteContentLabel else { return }
        let xPosition = CGFloat(slider.value)
        
        label.center.x = xPosition
    }
    
    @objc func changeShadowOffsetX(_ slider: UISlider) {
        guard let label = self.editQuoteController?.quoteView.quoteContentLabel else { return }
        
        let xOffset = CGFloat(slider.value)
        
        label.layer.shadowOffset = CGSize(width: xOffset, height: label.layer.shadowOffset.height)
        
    }
    
    @objc func changeShadowOffsetY(_ slider: UISlider) {
        guard let label = self.editQuoteController?.quoteView.quoteContentLabel else { return }
        
        let yOffset = CGFloat(slider.value)
        
        label.layer.shadowOffset = CGSize(width: label.layer.shadowOffset.width, height: yOffset)
    }
    
    @objc func changeShadowRadius(_ slider: UISlider) {
        let radius = CGFloat(slider.value)
        shadowRadius(radius: radius)
    }
    
    @objc func changeShadowOpacity(_ slider: UISlider) {
        let alpha = slider.value
        shadowOpacity(alpha: alpha)
    }
    
}
