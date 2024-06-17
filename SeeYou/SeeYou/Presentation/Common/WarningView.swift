//
//  WarningView.swift
//  SeeYou
//
//  Created by 배남석 on 5/27/24.
//

import UIKit
import SnapKit

final class WarningView: UIView {
    // MARK: - UI properties
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .Tip)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textColor = .Palette.gray700
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .Palette.gray500
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        
        return label
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    init(title: String, description: String) {
        super.init(frame: .zero)
        
        setupViews()
        configureUI(title, description)
    }
    
    convenience init() {
        self.init(title: SYText.warning_title, description: SYText.warning_description)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        configureUI(SYText.warning_title, SYText.warning_description)
    }
    
    // MARK: - Helpers
}

// MARK: - Setup & Configure UI
extension WarningView {
    enum Constants {
        enum ImageView {
            static let topMargin: CGFloat = .toScaledHeight(value: 16)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 16)
            static let height: CGFloat = .toScaledHeight(value: 20)
            static let width: CGFloat = .toScaledHeight(value: 20)
        }
        
        enum TitleLabel {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 4)
        }
        
        enum DescriptionLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 2)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
        }
    }
    
    private func setupViews() {
        [
            imageView,
            titleLabel,
            descriptionLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func configureUI(_ titleText: String, _ descriptionText: String) {
        backgroundColor = .Palette.gray100
        layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        clipsToBounds = true
        
        configureImageView()
        configureTitleLabel(titleText)
        configureDescriptionLabel(descriptionText)
    }
    
    private func configureImageView() {
        imageView.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(Constants.ImageView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ImageView.leadingMargin)
            $0.height.equalTo(Constants.ImageView.height)
            $0.width.equalTo(Constants.ImageView.width)
        }
    }
    
    private func configureTitleLabel(_ text: String) {
        titleLabel.text = text
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.leading.equalTo(imageView.snp.trailing).offset(Constants.TitleLabel.leadingMargin)
        }
    }
    
    private func configureDescriptionLabel(_ text: String) {
        descriptionLabel.text = text
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.DescriptionLabel.topMargin)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailingMargin.equalToSuperview().offset(Constants.DescriptionLabel.trailingMargin)
        }
    }
}
