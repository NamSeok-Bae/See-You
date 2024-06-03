//
//  SignUpVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class SignUpVC: UIViewController {
    // MARK: - UI properties
    private lazy var multiplyButton = UIBarButtonItem(
        image: .multiply,
        style: .plain,
        target: self,
        action: nil
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
    
    private let signUpCustomerView = SignUpButtonView(
        titleText: SYText.signup_customer_title,
        descriptionText: SYText.signup_customer_description,
        backgroundColor: .Palette.primary500,
        textColor: .Palette.gray0,
        image: .signup_customer)
    
    private let signUpGuideView = SignUpButtonView(
        titleText: SYText.signup_guide_title,
        descriptionText: SYText.signup_guide_description,
        backgroundColor: .Palette.yellow,
        textColor: .Palette.gray1000,
        image: .signup_customer)
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let viewModel: SignUpVM
    
    // MARK: - Lifecycles
    init(viewModel: SignUpVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setupViews()
        setupNavigationBar()
        configureUI()
    }
    
    // MARK: - Helpers
    private func bind() {
        let input = SignUpVM.Input(
            multiplyButtonDidTapped: multiplyButton.rx.tap.asObservable(),
            signUpCustomerViewDidTapped: 
                signUpCustomerView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .map { _ in }.asObservable(),
            signUpGuideViewDidTapped: 
                signUpGuideView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .map { _ in }.asObservable())
        
        let output = viewModel.transform(input: input)
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
            signUpCustomerView,
            signUpGuideView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
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
        signUpCustomerView.snp.makeConstraints {
            $0.height.equalTo(Constants.SignUpView.height)
        }
    }
    
    private func configureSignUpGuideView() {
        signUpGuideView.snp.makeConstraints {
            $0.height.equalTo(Constants.SignUpView.height)
        }
    }
}
