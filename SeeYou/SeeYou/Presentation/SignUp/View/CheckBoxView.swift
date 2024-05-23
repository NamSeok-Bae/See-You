//
//  CheckBoxView.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import UIKit

protocol CheckBoxViewDelegate: AnyObject {
    func validateButtonTags(_ tag: Int)
    func touchUpLabelButton(_ tag: Int)
}

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
        let imageConfig = UIImage.SymbolConfiguration(
            pointSize: Constants.CheckBoxButton.height,
            weight: .light)
        let image = UIImage(systemName: "square")?
            .withConfiguration(imageConfig)
            .withTintColor(.Palette.gray400, renderingMode: .alwaysOriginal)
        let fillImage = UIImage(systemName: "checkmark.square.fill")?
            .withConfiguration(imageConfig)
            .withTintColor(.Palette.primary500, renderingMode: .alwaysOriginal)
        
        button.setImage(image, for: .normal)
        button.setImage(fillImage, for: .selected)
        button.addTarget(
            self,
            action: #selector(buttonDidTapped(_:)),
            for: .touchUpInside)
        button.tag = 0
        
        return button
    }()
    
    private lazy var labelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.Palette.gray1000, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(
            self,
            action: #selector(buttonDidTapped(_:)),
            for: .touchUpInside)
        button.tag = 1
        
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: CheckBoxViewDelegate?
    
    // MARK: - Lifecycles
    init(text: String, underLine: Bool) {
        super.init(frame: .zero)
        
        setupViews()
        configureUI()
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
    
    @objc private func buttonDidTapped(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 0:
            print("checkbox button tapped")
            checkBoxButton.isSelected = checkBoxButton.isSelected ? false : true
            delegate?.validateButtonTags(self.tag)
        case 1:
            print("label Button Tapped")
            checkBoxButton.isSelected = checkBoxButton.isSelected ? false : true
            delegate?.touchUpLabelButton(self.tag)
        default:
            break
        }
    }
}
