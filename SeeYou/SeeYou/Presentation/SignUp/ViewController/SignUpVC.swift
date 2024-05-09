//
//  SignUpVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit
import SnapKit
import RxSwift

class SignUpVC: UIViewController {
    // MARK: - UI properties
    private lazy var multiplyButton = UIBarButtonItem(
        image: .multiply,
        style: .plain,
        target: self,
        action: #selector(buttonDidTapped(_:))
    )
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.signup_title
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .Palette.gray1000
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.signup_description
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .Palette.gray700
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = CGFloat.toScaledHeight(value: 8)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let signup_customber_view = SignUpButtonView(
        titleText: SYText.signup_customer_title,
        descriptionText: SYText.signup_customer_description,
        backgroundColor: .Palette.primary500,
        textColor: .Palette.gray0,
        image: .signup_customer)
    
    private let signup_guide_view = SignUpButtonView(
        titleText: SYText.signup_guide_title,
        descriptionText: SYText.signup_guide_description,
        backgroundColor: .Palette.yellow,
        textColor: .Palette.gray1000,
        image: .signup_customer)
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigationBar()
        configureUI()
    }
    
    // MARK: - Helpers
    @objc private func buttonDidTapped(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc private func viewDidTapped(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        
        switch tag {
        case 1:
            print("Did Tapped sign_customer_view")
            let vc = SignUpBottomSheetVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        case 2:
            print("Did Tapped sign_guide_view")
        default:
            break
        }
    }
}

// MARK: - Setup & Configure Functions
extension SignUpVC {
    enum Constants {
        enum Common {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum TitleLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 32)
        }
        
        enum DescriptionLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 16)
        }
        
        enum StackView {
            static let topMargin: CGFloat = .toScaledHeight(value: 60)
        }
        
        enum SignUpView {
            static let height: CGFloat = .toScaledHeight(value: 80)
        }
    }
    
    private func setupViews() {
        [
            titleLabel,
            descriptionLabel,
            stackView
        ].forEach { self.view.addSubview($0) }
        
        [
            signup_customber_view,
            signup_guide_view
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setTapGesture(targetView: UIView) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(viewDidTapped(_:)))
        targetView.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = multiplyButton
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        configureTitleLabel()
        configureDescriptionLabel()
        configureStackView()
        configureSignUpGuideView()
        configureSignUpCustomerView()
    }
    
    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.TitleLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.Common.leadingMargin)
        }
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.DescriptionLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.Common.leadingMargin)
        }
    }
    
    private func configureStackView() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.StackView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.Common.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.Common.trailingMargin)
        }
    }
    
    private func configureSignUpCustomerView() {
        signup_customber_view.tag = 1
        setTapGesture(targetView: signup_customber_view)
        signup_customber_view.snp.makeConstraints {
            $0.height.equalTo(Constants.SignUpView.height)
        }
    }
    
    private func configureSignUpGuideView() {
        signup_guide_view.tag = 2
        setTapGesture(targetView: signup_guide_view)
        signup_guide_view.snp.makeConstraints {
            $0.height.equalTo(Constants.SignUpView.height)
        }
    }
}
