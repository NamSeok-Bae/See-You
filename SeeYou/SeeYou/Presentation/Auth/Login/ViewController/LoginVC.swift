//
//  LoginVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol LoginVCDelegate: AnyObject {
    func touchUpMultiplyButton()
}

class LoginVC: UIViewController {
    // MARK: - UI properties
    private lazy var multiplyButton = UIBarButtonItem(
        image: .multiply,
        style: .plain,
        target: self,
        action: nil
    )
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.email
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .Palette.gray700
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: SYText.email_use_placeholder,
            attributes: [.foregroundColor : UIColor.Palette.gray500])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        textField.layer.borderColor = UIColor.Palette.gray200.cgColor
        textField.layer.borderWidth = 1
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = view
        textField.leftViewMode = .always
        textField.rightView = view
        textField.rightViewMode = .always
        textField.delegate = self
        
        return textField
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.email_validate_error
        label.textColor = .Palette.red500
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.password
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .Palette.gray700
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: SYText.password_placeholder,
            attributes: [.foregroundColor : UIColor.Palette.gray500])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        textField.layer.borderColor = UIColor.Palette.gray200.cgColor
        textField.layer.borderWidth = 1
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = view
        textField.leftViewMode = .always
        textField.rightView = view
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        return textField
    }()
    
    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.password_validate_error
        label.textColor = .Palette.red500
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle(SYText.login, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.setTitleColor(UIColor(hexString: "BDBDBD"), for: .disabled)
        button.setBackgroundColor(.Palette.gray100, for: .disabled)
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.layer.borderColor = UIColor.clear.cgColor
        
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(SYText.signup, for: .normal)
        button.setTitleColor(.Palette.primary500, for: .normal)
        button.layer.borderColor = UIColor.Palette.primary500.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.layer.backgroundColor = UIColor.Palette.gray0.cgColor
        
        return button
    }()
    
    private lazy var passwordResetButton: UIButton = {
        let button = UIButton()
        let text = SYText.password_reset
        button.setTitleColor(.Palette.gray700, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: text.count))
        button.setAttributedTitle(attributedString, for: .normal)
        
        return button
    }()
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    weak var delegate: LoginVCDelegate?
    private let viewModel: LoginVM
    
    // MARK: - Lifecycles
    init(viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigationBar()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesEnded(touches, with: event)
      self.view.endEditing(true)
    }
    
    private func bind() {
        let input = LoginVM.Input(
            multiplyButtonDidTapped: multiplyButton.rx.tap.asObservable(),
            loginButtonDidTapped: loginButton.rx.tap.map {
                (self.emailTextField.text ?? "", self.passwordTextField.text ?? "")
            }.asObservable(),
            signUpButtonDidTapped: signUpButton.rx.tap.asObservable(),
            passwordResetButtonDidTapped: passwordResetButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidateLogin
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValidateLogin in
                guard let self else { return }
                
                if isValidateLogin {
                    emailTextField.layer.borderColor = UIColor.Palette.gray200.cgColor
                    passwordTextField.layer.borderColor = UIColor.Palette.gray200.cgColor
                    emailErrorLabel.isHidden = true
                    passwordErrorLabel.isHidden = true
                } else {
                    emailTextField.layer.borderColor = UIColor.Palette.red500.cgColor
                    passwordTextField.layer.borderColor = UIColor.Palette.red500.cgColor
                    emailErrorLabel.isHidden = false
                    passwordErrorLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            emailTextField.rx.text.orEmpty.skip(1).distinctUntilChanged(),
            passwordTextField.rx.text.orEmpty.skip(1).distinctUntilChanged(),
            resultSelector: { (email: String, password: String) in
            return (email, password)
            }).subscribe(onNext: { event in
                if event.0.count > 0 && event.1.count > 0 {
                    self.loginButton.isEnabled = true
                } else {
                    self.loginButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - UITextField Delegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.tintColor = .Palette.primary500
        return true
    }
}

// MARK: - Setup & Configure Functions
extension LoginVC {
    enum Constants {
        enum ImageView {
            static let topMargin: CGFloat = .toScaledHeight(value: 24)
            static let height: CGFloat = .toScaledHeight(value: 40)
            static let width: CGFloat = .toScaledWidth(value: 64.8)
        }
        enum Label {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
        }
        
        enum TextField {
            static let leadingTrailingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum ErrorLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 4)
            static let leadingTrailingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum LoginButton {
            static let leadingTrailingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 32)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum SignUpButton {
            static let leadingTrailingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum PasswordResetLabel {
            static let trailingMargin: CGFloat = .toScaledWidth(value: 20)
            static let topMargin: CGFloat = .toScaledHeight(value: 16)
            static let height: CGFloat = .toScaledHeight(value: 20)
        }
    }
    
    private func setupViews() {
        [
            logoImageView,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            loginButton,
            signUpButton,
            passwordResetButton,
            emailErrorLabel,
            passwordErrorLabel
        ].forEach { self.view.addSubview($0) }
    }
    
    private func setupNavigationBar() {
        title = SYText.login
        navigationItem.rightBarButtonItem = multiplyButton
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        configureLogoImageView()
        configureEmailLabel()
        configureEmailTextfield()
        configurePasswordLabel()
        configurePasswordTextField()
        configureLoginButton()
        configureSignUpButton()
        configurePasswordResetLabel()
        configureEmailErrorLabel()
        configurePasswordErrorLabel()
    }
    
    private func configureLogoImageView() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.ImageView.topMargin)
            $0.height.equalTo(Constants.ImageView.height)
            $0.width.equalTo(Constants.ImageView.width)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func configureEmailLabel() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(Constants.Label.topMargin)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.Label.leadingMargin)
        }
    }
    
    private func configureEmailTextfield() {
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(Constants.TextField.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.TextField.leadingTrailingMargin)
            $0.height.equalTo(Constants.TextField.height)
        }
    }
    
    private func configurePasswordLabel() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.Label.topMargin)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(Constants.Label.leadingMargin)
        }
    }
    
    private func configurePasswordTextField() {
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(Constants.TextField.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.TextField.leadingTrailingMargin)
            $0.height.equalTo(Constants.TextField.height)
        }
    }
    
    private func configureLoginButton() {
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Constants.LoginButton.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.LoginButton.leadingTrailingMargin)
            $0.height.equalTo(Constants.LoginButton.height)
        }
    }
    
    private func configureSignUpButton() {
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(Constants.SignUpButton.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.SignUpButton.leadingTrailingMargin)
            $0.height.equalTo(Constants.SignUpButton.height)
        }
    }
    
    private func configurePasswordResetLabel() {
        passwordResetButton.snp.makeConstraints {
            $0.top.equalTo(signUpButton.snp.bottom).offset(Constants.PasswordResetLabel.topMargin)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.PasswordResetLabel.trailingMargin)
            $0.height.equalTo(Constants.PasswordResetLabel.height)
        }
    }
    
    private func configureEmailErrorLabel() {
        emailErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.ErrorLabel.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.ErrorLabel.leadingTrailingMargin)
        }
    }
    
    private func configurePasswordErrorLabel() {
        passwordErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Constants.ErrorLabel.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.ErrorLabel.leadingTrailingMargin)
        }
    }
}

