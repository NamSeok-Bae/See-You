//
//  SignUpEmailConfirmVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/21.
//

import UIKit
import SnapKit
import RxSwift

class SignUpEmailConfirmVC: UIViewController {
    // MARK: - UI properties
    private lazy var multiplyButton = UIBarButtonItem(
        image: .multiply,
        style: .plain,
        target: self,
        action: #selector(buttonDidTapped(_:))
    )
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = SYText.email_confirm_title
        label.textColor = .Palette.gray1000
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        label.text = SYText.email
        label.textColor = .Palette.gray700
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: SYText.email_use_placeholder,
            attributes: [.foregroundColor : UIColor.Palette.gray500])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        label.sizeToFit()
        
        return label
    }()
    
    private let confirmLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.password
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .Palette.gray700
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var confirmTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: SYText.email_confirm_number_placeholder,
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
    
    private let confirmErrorLabel: UILabel = {
        let label = UILabel()
        label.text = SYText.email_confirm_validate_error
        label.textColor = .Palette.red500
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.sizeToFit()
        label.isHidden = true
        
        return label
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.setBackgroundColor(.Palette.primary500.withAlphaComponent(0.4), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle(SYText.temporary_code_send, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        button.isEnabled = false
        button.tag = 1
        
        return button
    }()
    
    private lazy var resendButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitle(SYText.resend, for: .normal)
        button.setTitleColor(.Palette.primary500, for: .normal)
        button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
        button.tag = 2
        
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Palette.red500
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.sizeToFit()
        
        return label
    }()
    
    private let warningView = WarningView()
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    private let timer = DefaultBackgroundTimer()
    private var time = 0
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setupViews()
        setupNavigationBar()
        configureUI()
    }
    
    // MARK: - Helpers
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesEnded(touches, with: event)
      self.view.endEditing(true)
    }
    
    private func bind() {
        emailTextField.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { string in
                self.bottomButton.isEnabled = string.count > 0 ? true : false
            }).disposed(by: disposeBag)
        
        confirmTextField.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { string in
                self.bottomButton.isEnabled = string.count > 0 ? true : false
            }).disposed(by: disposeBag)
    }
    
    @objc private func buttonDidTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("MultiplyButton"), object: nil)
        case 1:
            if validateEmail(emailTextField.text ?? "") {
                emailErrorLabel.isHidden = true
                emailTextField.layer.borderColor = UIColor.Palette.gray200.cgColor
                emailTextField.isEnabled = false
                setupConfirmViews()
                configureConfirmLabel()
                configureConfirmTextField()
                configureConfirmErrorLabel()
                configureBottomButtonByConfirm()
                configureResendButton()
                configureTimerLabel()
                startRepeatTimer()
                bottomButton.tag = 3
                bottomButton.isEnabled = false
            } else {
                emailErrorLabel.isHidden = false
                emailTextField.layer.borderColor = UIColor.Palette.red500.cgColor
            }
        case 2:
            confirmTextField.layer.borderColor = UIColor.Palette.gray200.cgColor
            confirmErrorLabel.isHidden = true
            startRepeatTimer()
        case 3:
            print("인증하기 버튼 탭드")
        default:
            break
        }
    }
    
    private func validateEmail(_ input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = emailPredicate.evaluate(with: input)

        return isValid
    }
    
    private func startRepeatTimer() {
        timer.start(durationSeconds: 10) {
            DispatchQueue.main.async {
                self.time += 1
                let realTime = 10 - self.time
                self.timerLabel.text = String(format: "%02d:%02d", realTime / 60, realTime % 60)
            }
        } completion: {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.timerLabel.text = "00:00"
                self.confirmTextField.layer.borderColor = UIColor.Palette.primary500.cgColor
                self.confirmErrorLabel.isHidden = false
                self.time = 0
                self.timer.cancel()
            }
        }
    }
}

// MARK: - UITextField Delegate
extension SignUpEmailConfirmVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.tintColor = .Palette.primary500
        return true
    }
}

// MARK: - Setup & Configure UI
extension SignUpEmailConfirmVC {
    enum Constants {
        enum TitleLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 32)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum EmailLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 36)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum EmailTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum EmailErrorLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 4)
        }
        
        enum ConfirmLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum ConfirmTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum ConfirmErrorLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 4)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum BottomButton {
            static let topMargin: CGFloat = .toScaledHeight(value: 32)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum ResendButton {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
            static let height: CGFloat = .toScaledHeight(value: 22)
        }
        
        enum TimerLabel {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
        }
        
        enum WarningView {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 88)
        }
    }
    
    private func setupViews() {
        [
            titleLabel,
            emailLabel,
            emailTextField,
            emailErrorLabel,
            bottomButton,
            warningView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConfirmViews() {
        [
            confirmLabel,
            confirmTextField,
            confirmErrorLabel
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupNavigationBar() {
        title = SYText.signup
        navigationItem.rightBarButtonItem = multiplyButton
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Palette.gray1000]
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        configureTitleLabel()
        configureEmailLabel()
        configureEmailTextField()
        configureEmailErrorLabel()
        configureBottomButton()
        configureWarningView()
    }
    
    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.TitleLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TitleLabel.leadingMargin)
        }
    }
    
    private func configureEmailLabel() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.EmailLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.EmailLabel.leadingMargin)
        }
    }
    
    private func configureEmailTextField() {
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(Constants.EmailTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.EmailTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.EmailTextField.trailingMargin)
            $0.height.equalTo(Constants.EmailTextField.height)
        }
    }
    
    private func configureEmailErrorLabel() {
        emailErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.EmailErrorLabel.topMargin)
            $0.leading.equalTo(emailTextField.snp.leading)
        }
    }
    
    private func configureConfirmLabel() {
        confirmLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.ConfirmLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ConfirmLabel.leadingMargin)
        }
    }
    
    private func configureConfirmTextField() {
        confirmTextField.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(Constants.ConfirmTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ConfirmTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.ConfirmTextField.trailingMargin)
            $0.height.equalTo(Constants.ConfirmTextField.height)
        }
    }
    
    private func configureConfirmErrorLabel() {
        confirmErrorLabel.snp.makeConstraints {
            $0.top.equalTo(confirmTextField.snp.bottom).offset(Constants.ConfirmErrorLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ConfirmErrorLabel.leadingMargin)
        }
    }
    
    private func configureBottomButton() {
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.BottomButton.topMargin)
            $0.leading.equalToSuperview().offset(Constants.BottomButton.leadingMargin)
            $0.trailingMargin.equalToSuperview().offset(Constants.BottomButton.trailingMargin)
            $0.height.equalTo(Constants.BottomButton.height)
        }
    }
    
    private func configureBottomButtonByConfirm() {
        bottomButton.snp.remakeConstraints {
            $0.top.equalTo(confirmTextField.snp.bottom).offset(Constants.BottomButton.topMargin)
            $0.leading.equalToSuperview().offset(Constants.BottomButton.leadingMargin)
            $0.trailingMargin.equalToSuperview().offset(Constants.BottomButton.trailingMargin)
            $0.height.equalTo(Constants.BottomButton.height)
        }
    }
    
    private func configureResendButton() {
        view.addSubview(resendButton)
        
        resendButton.snp.makeConstraints {
            $0.centerY.equalTo(emailTextField.snp.centerY)
            $0.trailing.equalTo(emailTextField.snp.trailing).offset(Constants.ResendButton.trailingMargin)
            $0.height.equalTo(Constants.ResendButton.height)
            $0.width.equalTo(resendButton.intrinsicContentSize.width)
        }
    }
    
    private func configureTimerLabel() {
        view.addSubview(timerLabel)
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(confirmTextField.snp.centerY)
            $0.trailing.equalTo(confirmTextField.snp.trailing).offset(Constants.TimerLabel.trailingMargin)
        }
    }
    
    private func configureWarningView() {
        warningView.snp.makeConstraints {
            $0.height.equalTo(Constants.WarningView.height)
            $0.leading.equalToSuperview().offset(Constants.WarningView.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.WarningView.trailingMargin)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(Constants.WarningView.bottomMargin)
        }
    }
}
