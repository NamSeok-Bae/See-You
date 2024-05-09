//
//  SignUpBottomSheetVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import UIKit
import SnapKit

class SignUpBottomSheetVC: UIViewController {
    // MARK: - UI properties
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = CGFloat.toScaledHeight(value: 16)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private let leftBarItem: UILabel = {
        let label = UILabel()
        label.text = SYText.terms_of_use
        label.tintColor = .Palette.gray1000
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var rightBarItem: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constants.RightBarItem.height, weight: .light)
        let image = UIImage.multiply?.withConfiguration(imageConfig)
        
        button.setImage(image, for: .normal)
        button.tintColor = .Palette.gray1000
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = CGFloat.toScaledHeight(value: 24)
        
        return stackView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Palette.primary500
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle(SYText.agree_and_continue, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        button.tag = 1
        
        return button
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setTapGesture()
        configureUI()
    }
    
    // MARK: - Helpers
    @objc private func buttonDidTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 0:
            self.dismiss(animated: true)
        case 1:
            print("continue button tapped")
        default:
            break
        }
    }
    
    @objc private func viewDidTapped(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
}

// MARK: - Setup & Configure UI
extension SignUpBottomSheetVC {
    enum Constants {
        enum BottomSheetView {
            static let height: CGFloat = .toScaledHeight(value: 354)
        }
        
        enum LeftBarItem {
            static let topMarign: CGFloat = .toScaledHeight(value: 32)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum RightBarItem {
            static let topMarign: CGFloat = .toScaledHeight(value: 32)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 24)
            static let width: CGFloat = .toScaledHeight(value: 24)
        }
        
        enum StackView {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 160)
        }
        
        enum ContinueButton {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let bottomMargin: CGFloat = .toScaledWidth(value: -32)
        }
    }
    
    private func setupViews() {
        [
            dimmedView,
            bottomSheetView
        ].forEach {
            view.addSubview($0)
        }
        
        [
            leftBarItem,
            rightBarItem,
            stackView,
            continueButton
        ].forEach {
            bottomSheetView.addSubview($0)
        }
        
        [
            CheckBoxView(text: SYText.terms_of_age, underLine: false),
            CheckBoxView(text: SYText.terms_of_service, underLine: true),
            CheckBoxView(text: SYText.terms_of_information, underLine: true),
            CheckBoxView(text: SYText.terms_of_marketing, underLine: true)
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(viewDidTapped(_:)))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    private func configureUI() {
        configureDimmedView()
        configureBottomSheetView()
        configureLeftBarItem()
        configureRightBarItem()
        configureStackView()
        configureContinueButton()
    }
    
    private func configureDimmedView() {
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureBottomSheetView() {
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.BottomSheetView.height)
        }
    }
    
    private func configureLeftBarItem() {
        leftBarItem.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.LeftBarItem.topMarign)
            $0.leading.equalToSuperview().offset(Constants.LeftBarItem.leadingMargin)
        }
    }
    
    private func configureRightBarItem() {
        rightBarItem.snp.makeConstraints {
            $0.centerY.equalTo(leftBarItem.snp.centerY)
            $0.trailing.equalToSuperview().offset(Constants.RightBarItem.trailingMargin)
            $0.height.equalTo(Constants.RightBarItem.height)
            $0.width.equalTo(Constants.RightBarItem.width)
        }
    }
    
    private func configureStackView() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.StackView.leadingMargin)
            $0.top.equalTo(leftBarItem.snp.bottom).offset(Constants.StackView.topMargin)
            $0.trailing.equalToSuperview().offset(Constants.StackView.trailingMargin)
            $0.height.equalTo(Constants.StackView.height)
        }
    }
    
    private func configureContinueButton() {
        continueButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.ContinueButton.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.ContinueButton.trailingMargin)
            $0.top.equalTo(stackView.snp.bottom).offset(Constants.ContinueButton.topMargin)
            $0.bottom.equalToSuperview().offset(Constants.ContinueButton.bottomMargin)
        }
    }
}
