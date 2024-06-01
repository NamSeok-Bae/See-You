//
//  SignUpButtonView.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import UIKit
import SnapKit

class SignUpButtonView: UIView {
    enum Constants {
        enum TitleLabel {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 16.5)
        }
        
        enum DescriptionLabel {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 2)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -16.5)
        }
        
        enum ArrowImageView {
            static let width: CGFloat = .toScaledWidth(value: 20)
            static let height: CGFloat = .toScaledHeight(value: 18)
        }
        
        enum ImageView {
            static let width: CGFloat = .toScaledHeight(value: 48)
            static let height: CGFloat = .toScaledHeight(value: 48)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
    }
    
    // MARK: - UI properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .right_arrow?.withRenderingMode(.alwaysTemplate)
        
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    init(titleText: String, descriptionText: String, backgroundColor: UIColor, textColor: UIColor, image: UIImage?) {
        super.init(frame: .zero)
        
        setupViews()
        setupAttribute(titleText, descriptionText, backgroundColor, image)
        configureTextColor(color: textColor)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupAttribute("오류가 발생했습니다.", "오류가 발생했습니다.", .red, UIImage())
    }
    
    // MARK: - Helpers
    private func setupViews() {
        [
            titleLabel,
            descriptionLabel,
            arrowImageView,
            imageView
        ].forEach {
            self.addSubview($0)
        }
    }
    
    private func setupAttribute(
        _ titleText: String,
        _ descriptionText: String,
        _ backgroundColor: UIColor,
        _ image: UIImage?) {
            titleLabel.text = titleText
            descriptionLabel.text = descriptionText
            self.backgroundColor = backgroundColor
            imageView.image = image
    }
    
    private func configureTextColor(color: UIColor) {
        titleLabel.textColor = color
        descriptionLabel.textColor = color
        arrowImageView.tintColor = color
    }
    
    private func configureUI() {
        self.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        self.clipsToBounds = true
        
        configureTitleLabel()
        configureDescriptionLabel()
        configureArrowImageView()
        configureImageView()
    }
    
    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.TitleLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TitleLabel.leadingMargin)
        }
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.DescriptionLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.DescriptionLabel.leadingMargin)
            $0.bottom.equalToSuperview().offset(Constants.DescriptionLabel.bottomMargin)
        }
    }
    
    private func configureArrowImageView() {
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.width.equalTo(Constants.ArrowImageView.width)
            $0.height.equalTo(titleLabel.snp.height)
        }
    }
    
    private func configureImageView() {
        imageView.snp.makeConstraints {
            $0.height.equalTo(Constants.ImageView.height)
            $0.width.equalTo(Constants.ImageView.width)
            $0.trailing.equalToSuperview().offset(Constants.ImageView.trailingMargin)
            $0.centerY.equalToSuperview()
        }
    }
}
