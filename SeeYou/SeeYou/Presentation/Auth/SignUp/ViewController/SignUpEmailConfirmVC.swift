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
        action: nil
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
    
    private lazy var temporaryCodeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.setBackgroundColor(.Palette.primary500.withAlphaComponent(0.4), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle(SYText.temporary_code_send, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.setBackgroundColor(.Palette.primary500.withAlphaComponent(0.4), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle(SYText.temporary_code_send, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.isEnabled = false
        button.isHidden = true
        
        return button
    }()
    
    private lazy var resendButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitle(SYText.resend, for: .normal)
        button.setTitleColor(.Palette.primary500, for: .normal)
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
    private let disposeBag = DisposeBag()
    private var timer = Timer()
    private var time = 0
    private let viewModel: SignUpEmailConfirmVM
    
    // MARK: - Lifecycles
    init(viewModel: SignUpEmailConfirmVM) {
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesEnded(touches, with: event)
      self.view.endEditing(true)
    }
    
    private func bind() {
        let input = SignUpEmailConfirmVM.Input(
            multiplyButtonDidTapped: multiplyButton.rx.tap.asObservable(),
            temporaryCodeButtonDidTapped: 
                temporaryCodeButton.rx.tap.map {
                    _ in self.emailTextField.text ?? ""
                }.asObservable(),
            confirmButtonDidTapped:
                confirmButton.rx.tap.map {
                    _ in self.confirmTextField.text ?? ""
                }.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidateTemporaryCode
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValidate in
                guard let self else { return }
                if isValidate {
                    emailErrorLabel.isHidden = true
                    emailTextField.layer.borderColor = UIColor.Palette.gray200.cgColor
                    emailTextField.isEnabled = false
                    temporaryCodeButton.isHidden = true
                    resendButton.isEnabled = false
                    setupConfirmViews()
                    configureConfirmLabel()
                    configureConfirmTextField()
                    configureConfirmErrorLabel()
                    configureConfirmButton()
                    configureResendButton()
                    configureTimerLabel()
                    setTimer(startTime: Date())
                } else {
                    emailErrorLabel.isHidden = false
                    emailTextField.layer.borderColor = UIColor.Palette.red500.cgColor
                }
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { string in
                self.temporaryCodeButton.isEnabled = string.count > 0 ? true : false
            })
            .disposed(by: disposeBag)
        
        confirmTextField.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { string in
                self.confirmButton.isEnabled = string.count > 0 ? true : false
            })
            .disposed(by: disposeBag)
        
        resendButton.rx.tap
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                confirmTextField.layer.borderColor = UIColor.Palette.gray200.cgColor
                confirmErrorLabel.isHidden = true
                resendButton.isEnabled = false
                setTimer(startTime: Date())
            })
            .disposed(by: disposeBag)
    }
    
    private func setTimer(startTime: Date) {
        self.timerLabel.text = String(format: "%02d:%02d", 10 / 60, 10 % 60)
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
                let expireLimit = 10

                guard elapsedTimeSeconds <= expireLimit else {
                    timer.invalidate()
                    self?.timerLabel.text = "00:00"
                    self?.confirmTextField.layer.borderColor = UIColor.Palette.primary500.cgColor
                    self?.confirmErrorLabel.isHidden = false
                    self?.resendButton.isEnabled = true
                    return
                }

                let remainSeconds = expireLimit - elapsedTimeSeconds
                self?.timerLabel.text = String(format: "%02d:%02d", remainSeconds / 60, remainSeconds % 60)
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
        
        enum TemporaryCodeButton {
            static let topMargin: CGFloat = .toScaledHeight(value: 32)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum ConfirmButton {
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
            temporaryCodeButton,
            warningView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConfirmViews() {
        [
            confirmLabel,
            confirmTextField,
            confirmErrorLabel,
            confirmButton
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
        configureTemporaryCodeButton()
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
    
    private func configureTemporaryCodeButton() {
        temporaryCodeButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(Constants.TemporaryCodeButton.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TemporaryCodeButton.leadingMargin)
            $0.trailingMargin.equalToSuperview().offset(Constants.TemporaryCodeButton.trailingMargin)
            $0.height.equalTo(Constants.TemporaryCodeButton.height)
        }
    }
    
    private func configureConfirmButton() {
        confirmButton.isHidden = false
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(confirmTextField.snp.bottom).offset(Constants.ConfirmButton.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ConfirmButton.leadingMargin)
            $0.trailingMargin.equalToSuperview().offset(Constants.ConfirmButton.trailingMargin)
            $0.height.equalTo(Constants.ConfirmButton.height)
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
