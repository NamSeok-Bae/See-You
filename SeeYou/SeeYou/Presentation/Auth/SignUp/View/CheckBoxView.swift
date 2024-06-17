//
//  CheckBoxView.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import UIKit

class CheckBoxView: UIView {
    enum Constants {
        enum CheckBoxButton {
            static let height: CGFloat = .toScaledHeight(value: 20)
        }
        
        enum LabelButton {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 6)
        }
    }
    
    // MARK: - UI properties
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    private lazy var labelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.Palette.gray1000, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tag = 1
        
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    init(text: String, underLine: Bool = false, type: CheckBoxType = .square) {
        super.init(frame: .zero)
        
        setupViews()
        configureUI()
        setupCheckBox(type: type)
        if underLine { setUnderLineButtonText(text) }
        else { setButtonText(text) }
    }
    
    init(
        text: String,
        underLine: Bool = false,
        type: CheckBoxType = .square,
        checkBoxHanlder: (() -> Void)? = nil,
        labelHandler: (() -> Void)? = nil
    ) {
        super.init(frame: .zero)
        
        setupViews()
        configureUI()
        setupCheckBox(type: type, handler: checkBoxHanlder)
        setupLabel(handler: labelHandler)
        if underLine { setUnderLineButtonText(text) }
        else { setButtonText(text) }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        configureUI()
        setButtonText("잘못된 방법입니다.")
    }
    
    // MARK: - Helpers
    private func setupViews() {
        [
            checkBoxButton,
            labelButton
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setUnderLineButtonText(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text.count))
        labelButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    private func setButtonText(_ text: String) {
        labelButton.setTitle(text, for: .normal)
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        
        configureCheckBoxButton()
        configureLabelButton()
    }
    
    private func setupCheckBox(type: CheckBoxType, handler: (() -> Void)? = nil) {
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: Constants.CheckBoxButton.height,
            weight: .light)
        let image = UIImage(systemName: type.defaultImageName)?
            .withConfiguration(imageConfig)
            .withTintColor(.Palette.gray400, renderingMode: .alwaysOriginal)
        let fillImage = UIImage(systemName: type.checkImageName)?
            .withConfiguration(imageConfig)
            .withTintColor(.Palette.primary500, renderingMode: .alwaysOriginal)
        
        checkBoxButton.setImage(image, for: .normal)
        checkBoxButton.setImage(fillImage, for: .selected)
        checkBoxButton.addAction(
            UIAction(handler: { _ in
                self.checkBoxButton.isSelected = self.checkBoxButton.isSelected ? false : true
                handler?()
            }),
            for: .touchUpInside)
    }
    
    private func setupLabel(handler: (() -> Void)? = nil) {
        labelButton.addAction(
            UIAction(handler: { _ in handler?() }),
            for: .touchUpInside)
    }
    
    private func configureCheckBoxButton() {
        checkBoxButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }
    }
    
    private func configureLabelButton() {
        labelButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(checkBoxButton.snp.trailing).offset(Constants.LabelButton.leadingMargin)
        }
    }
    
    func check() {
        self.checkBoxButton.isSelected = true
    }
    
    func uncheck() {
        self.checkBoxButton.isSelected = false
    }
}
