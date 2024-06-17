//
//  SignUpSuccessVC.swift
//  SeeYou
//
//  Created by 배남석 on 6/12/24.
//

import UIKit
import RxSwift

final class SignUpCustomerSuccessVC: UIViewController {
    // MARK: - UI properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환영합니다!"
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.textColor = .Palette.gray1000
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입이 완료되었어요!"
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .Palette.gray1000
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "喜友와 함께 좋은 추억을 만들어보세요!"
        label.sizeToFit()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .Palette.gray700

        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "house")
        
        return imageView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configureUI()
    }
    
    // MARK: - Helpers
}

// MARK: - Setup & Configure UI
extension SignUpCustomerSuccessVC {
    enum Constants {
        enum TitleLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 88)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum SubTitleLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 2)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum DescriptionLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 12)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum ImageView {
            static let topMargin: CGFloat = .toScaledHeight(value: 94)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 72)
            static let height: CGFloat = .toScaledHeight(value: 500)
            static let width: CGFloat = .toScaledHeight(value: 500)
        }
        
        enum StartButton {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -22)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
    }
    
    private func setupViews() {
        [
            titleLabel,
            subTitleLabel,
            descriptionLabel,
            imageView,
            startButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureTitleLabel()
        configureSubTitleLabel()
        configureDescriptionLabel()
        configureImageView()
        configureStartButton()
    }
    
    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.TitleLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TitleLabel.leadingMargin)
        }
    }
    
    private func configureSubTitleLabel() {
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.SubTitleLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.SubTitleLabel.leadingMargin)
        }
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(Constants.DescriptionLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.DescriptionLabel.leadingMargin)
        }
    }
    
    private func configureImageView() {
        imageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.ImageView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ImageView.leadingMargin)
            $0.height.equalTo(Constants.ImageView.height)
            $0.width.equalTo(Constants.ImageView.width)
        }
    }
    
    private func configureStartButton() {
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(Constants.StartButton.bottomMargin)
            $0.leading.equalToSuperview().offset(Constants.StartButton.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.StartButton.trailingMargin)
            $0.height.equalTo(Constants.StartButton.height)
        }
    }
}
