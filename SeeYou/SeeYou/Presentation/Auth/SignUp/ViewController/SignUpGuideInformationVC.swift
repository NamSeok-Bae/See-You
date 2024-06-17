//
//  SignUpInformationVC.swift
//  SeeYou
//
//  Created by 배남석 on 6/3/24.
//

import UIKit
import TagListView
import RxSwift
import RxRelay
import RxKeyboard

class SignUpGuideInformationVC: UIViewController {
    // MARK: - UI properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = SYText.signup_info_title
        
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.password, isEssentail: true)
        
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = CommonTextField(placeholder: SYText.password_placeholder)
        textField.isSecureTextEntry = true
        textField.delegate = self
        
        return textField
    }()
    
    private let passwordErrorLabel = CommonErrorLabel(errorText: SYText.password_validate_error)
    
    private let nicknameLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.nickname, isEssentail: true)
        
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = CommonTextField(placeholder: SYText.nickname_placeholder)
        textField.delegate = self
        
        return textField
    }()
    
    private let nicknameErrorLabel = CommonErrorLabel(errorText: SYText.nickname_error,
                                                      successText: SYText.nickname_success)
    
    private let birthDateLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.birth_date, isEssentail: true)
        
        return label
    }()
    
    private lazy var birthDateTextField: UITextField = {
        let textField = CommonTextField(placeholder: SYText.birth_date_placeholder)
        textField.delegate = self
        
        return textField
    }()
    
    private let birthDateErrorLabel = CommonErrorLabel(errorText: SYText.birth_date_error)
    
    private let doubleCheckButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(.Palette.primary500, for: .normal)
        button.setTitleColor(.Palette.gray400, for: .disabled)
        button.isEnabled = false
        
        return button
    }()
    
    private let ageRangeLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.sizeToFit()
        label.textColor = .Palette.primary500
        label.textAlignment = .center
        
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.gender, isEssentail: true)
        
        return label
    }()
    
    private let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = .toScaledWidth(value: 40)
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var genderCheckBoxViews: [CheckBoxView] = [
        CheckBoxView(
            text: "여자",
            type: .circle,
            checkBoxHanlder: {
                self.genderCheckBoxViews[0].check()
                self.genderCheckBoxViews[1].uncheck()
                self.genderSelected.accept(0)
            }),
        CheckBoxView(
            text: "남자",
            type: .circle,
            checkBoxHanlder: {
                self.genderCheckBoxViews[0].uncheck()
                self.genderCheckBoxViews[1].check()
                self.genderSelected.accept(1)
            })
    ]
    
    private let nationalityLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.nationality, isEssentail: true)
        
        return label
    }()
    
    private let nationalityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = .toScaledWidth(value: 40)
        stackView.distribution = .fillEqually
        stackView.layoutMargins = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private lazy var nationalityCheckBoxViews: [CheckBoxView] = [
        CheckBoxView(
            text: "중국",
            type: .circle,
            checkBoxHanlder: {
                self.nationalityCheckBoxViews[0].check()
                self.nationalityCheckBoxViews[1].uncheck()
                self.nationalitySelected.accept(0)
                self.periodLabel.isHidden = false
                self.yearLabel.isHidden = false
                self.periodTextField.isHidden = false
                self.levelLabel.text = SYText.korean_level
                self.levelLabel.snp.remakeConstraints {
                    $0.top.equalTo(self.periodTextField.snp.bottom).offset(Constants.LevelLabel.topMargin)
                    $0.leading.equalToSuperview().offset(Constants.LevelLabel.leadingMargin)
                }
            }),
        CheckBoxView(
            text: "한국",
            type: .circle,
            checkBoxHanlder: {
                self.nationalityCheckBoxViews[0].uncheck()
                self.nationalityCheckBoxViews[1].check()
                self.nationalitySelected.accept(1)
                self.periodLabel.isHidden = true
                self.yearLabel.isHidden = true
                self.periodTextField.isHidden = true
                self.levelLabel.text = SYText.chinese_level
                self.levelLabel.snp.remakeConstraints {
                    $0.top.equalTo(self.nationalityStackView.snp.bottom).offset(Constants.LevelLabel.topMargin)
                    $0.leading.equalToSuperview().offset(Constants.LevelLabel.leadingMargin)
                }
            })
    ]
    
    private let periodLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.period_of_residence, isEssentail: true)
        
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "年"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .Palette.gray1000
        
        return label
    }()
    
    private lazy var periodTextField: UITextField = {
        let textField = CommonTextField(placeholder: SYText.period_of_residene_placeholder)
        textField.delegate = self
        
        return textField
    }()
    
    private let levelLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.korean_level, isEssentail: true)
        
        return label
    }()
    
    private lazy var levelSliderView: LevelSliderView = {
        let sliderView =  LevelSliderView(maxValue: 5)
        sliderView.delegate = self
        
        return sliderView
    }()
    
    private let activeAreaLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.active_area, isEssentail: true)
        
        return label
    }()
    
    private lazy var activeAreaAdditionButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage.plus?.withConfiguration(imageConfig)
        
        button.setTitle("추가", for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(.Palette.gray1000, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .Palette.gray1000
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var activeAreaTagListView: TagListView = {
        let view = TagListView()
        view.tagBackgroundColor = .Palette.gray0
        view.textColor = .Palette.primary500
        view.borderColor = .Palette.red500
        view.borderWidth = 1
        view.cornerRadius = 14
        view.paddingX = 16
        view.paddingY = 8
        view.marginX = 8
        view.marginY = 8
        view.enableRemoveButton = true
        view.removeIconLineColor = .Palette.primary500
        view.selectedBorderColor = .Palette.red500
        view.selectedTextColor = .Palette.primary500
        view.textFont = .systemFont(ofSize: 14)
        view.delegate = self
        
        return view
    }()
    
    private let provisionLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.provision_of_services, isEssentail: true)
    
        return label
    }()
    
    private lazy var provisionAdditionButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage.plus?.withConfiguration(imageConfig)
        
        button.setTitle("추가", for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(.Palette.gray1000, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .Palette.gray1000
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var provisionTagListView: TagListView = {
        let view = TagListView()
        view.tagBackgroundColor = .Palette.gray0
        view.textColor = .Palette.primary500
        view.borderColor = .Palette.red500
        view.borderWidth = 1
        view.cornerRadius = 14
        view.paddingX = 16
        view.paddingY = 8
        view.marginX = 8
        view.marginY = 8
        view.enableRemoveButton = true
        view.removeIconLineColor = .Palette.primary500
        view.selectedBorderColor = .Palette.red500
        view.selectedTextColor = .Palette.primary500
        view.textFont = .systemFont(ofSize: 14)
        view.delegate = self
        
        return view
    }()
    
    private let mbtiLabel: UILabel = {
        let label = CommonTitleLabel(text: "MBTI")
        
        return label
    }()
    
    private lazy var mbtiTextField: UITextField = {
        let textField = CommonTextField(placeholder: SYText.mbti_placeholder)
        textField.delegate = self
        
        return textField
    }()
    
    private let introduceLabel: UILabel = {
        let label = CommonTitleLabel(text: SYText.introduce_myself)
        
        return label
    }()
    
    private lazy var introduceTextField: UITextField = {
        let textField = CommonTextField(placeholder: SYText.introduce_myself_placeholder)
        
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.setBackgroundColor(.Palette.primary500.withAlphaComponent(0.4), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle(SYText.become_member, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    private let viewModel: SignUpGuideInformationVM
    private let disposeBag = DisposeBag()
    private var buttonTag = 1
    private var genderSelected = BehaviorRelay<Int>(value: 0)
    private var nationalitySelected = BehaviorRelay<Int>(value: 0)
    private let activeAreaTagDidRemoved = PublishRelay<String>()
    private let provisionTagDidRemoved = PublishRelay<String>()
    
    // MARK: - Lifecycles
    init(viewModel: SignUpGuideInformationVM) {
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
        let input = SignUpGuideInformationVM.Input(
            passwordTextFieldChanged:
                passwordTextField.rx.text.orEmpty.skip(1).distinctUntilChanged().asObservable(),
            birthDateTextFieldChanged:
                birthDateTextField.rx.text.orEmpty.skip(1).distinctUntilChanged().asObservable(),
            doubleCheckButtonDidTapped:
                doubleCheckButton
                .rx
                .tap
                .map { _ in self.nicknameTextField.text ?? "" }
                .asObservable(),
            genderSelected: genderSelected.asObservable(),
            nationalitySelected: nationalitySelected.asObservable(),
            signUpButtonDidTapped:
                signUpButton
                .rx
                .tap
                .map { _ in
                    let customerInfo = CustomerInfo(
                        password: self.passwordTextField.text ?? "",
                        nickname: self.nicknameTextField.text ?? "",
                        birthDate: self.birthDateTextField.text ?? "",
                        gender: self.genderSelected.value,
                        nationality: self.nationalitySelected.value,
                        mbti: self.mbtiTextField.text ?? "")
                    return customerInfo
                }
                .asObservable(),
            activeAreaAdditionButtonDidTapped: activeAreaAdditionButton.rx.tap.asObservable(),
            activeAreaTagDidRemoved: activeAreaTagDidRemoved.asObservable(),
            provisionAdditionButtonDidTapped: provisionAdditionButton.rx.tap.asObservable(),
            provisionTagDidRemoved: provisionTagDidRemoved.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidatePassword
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                guard let self else { return }
                passwordErrorLabel.isHidden = !isValid
            })
            .disposed(by: disposeBag)
        
        output.ageRangeText
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                ageRangeLabel.text = text
            })
            .disposed(by: disposeBag)
        
        output.doubleChecked
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isSucceed in
                guard let self else { return }
                nicknameErrorLabel.isSucceed = isSucceed
            })
            .disposed(by: disposeBag)
        
        output.essentialFilled
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isFilled in
                guard let self else { return }
                signUpButton.isEnabled = isFilled
            })
            .disposed(by: disposeBag)
        
        output.activeAreaTagSelected
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] texts in
                guard let self else { return }
                activeAreaTagListView.addTags(texts)
            })
            .disposed(by: disposeBag)
        
        output.provisionTagSelected
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] texts in
                guard let self else { return }
                provisionTagListView.addTags(texts)
            })
            .disposed(by: disposeBag)
        
        contentView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        nicknameTextField
            .rx
            .text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                doubleCheckButton.isEnabled = text.count > 0 ? true : false
                nicknameErrorLabel.isHidden = true
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(2)
            .drive(onNext: { keyboardVisibleHeight in
                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let self else { return }
                    self.contentView.snp.updateConstraints {
                        $0.bottom.equalTo(self.scrollView.contentLayoutGuide).inset(keyboardVisibleHeight)
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextField Delegate
extension SignUpGuideInformationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.tintColor = .Palette.primary500
        return true
    }
}

// MARK: - SliderView Delegate
extension SignUpGuideInformationVC: SliderViewDelegate {
    func sliderView(_ sender: LevelSliderView, changedValue value: Int) {
        
    }
}

// MARK: - TagListView Delegate
extension SignUpGuideInformationVC: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == activeAreaTagListView {
            self.activeAreaTagDidRemoved.accept(title)
            activeAreaTagListView.removeTagView(tagView)
        } else if sender == provisionTagListView {
            self.provisionTagDidRemoved.accept(title)
            provisionTagListView.removeTagView(tagView)
        }
    }
}

// MARK: - Setup & Configure UI
extension SignUpGuideInformationVC {
    enum Constants {
        enum TitleLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 32)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum PasswordLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 36)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum PasswordTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum PasswordErrorLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 4)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum NickNameLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum NickNameTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum NickNameErrorLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 4)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum DoubleCheckButton {
            static let topMargin: CGFloat = .toScaledHeight(value: 13)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -13)
            static let width: CGFloat = .toScaledWidth(value: 60)
        }
        
        enum BirthDateLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum BirthDateTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum BirthDateErrorLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 4)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
        }
        
        enum AgeRangeLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 13)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -13)
            static let width: CGFloat = .toScaledWidth(value: 33)
        }
        
        enum GenderLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum GenderStackView {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let height: CGFloat = .toScaledHeight(value: 48)
            static let width: CGFloat = .toScaledWidth(value: 148)
        }
        
        enum NationalityLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum NationalityStackView {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let height: CGFloat = .toScaledHeight(value: 48)
            static let width: CGFloat = .toScaledWidth(value: 148)
        }
        
        enum PeriodLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum YearLabel {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
        }
        
        enum PeriodTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum LevelLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum LevelSliderView {
            static let topMargin: CGFloat = .toScaledHeight(value: 12)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 53)
        }
        
        enum ActiveArea {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum ActiveAreaAdditionButton {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 20)
            static let width: CGFloat = .toScaledWidth(value: 46)
        }
        
        enum ActiveAreaTagListView {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let minHeight: CGFloat = 0
        }
        
        enum ProvisionLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum ProvisionAdditionButton {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 20)
            static let width: CGFloat = .toScaledWidth(value: 46)
        }
        
        enum ProvisionTagListView {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let minHeight: CGFloat = 0
        }
        
        enum MBTILabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum MBTITextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum SignUpButton {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -16)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum IntroduceLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 28)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum IntroduceTextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 8)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 94)
        }
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            titleLabel,
            passwordLabel,
            passwordTextField,
            passwordErrorLabel,
            nicknameLabel,
            nicknameTextField,
            nicknameErrorLabel,
            birthDateLabel,
            birthDateTextField,
            birthDateErrorLabel,
            genderLabel,
            genderStackView,
            nationalityLabel,
            nationalityStackView,
            periodLabel,
            yearLabel,
            periodTextField,
            levelLabel,
            levelSliderView,
            activeAreaLabel,
            activeAreaAdditionButton,
            activeAreaTagListView,
            provisionLabel,
            provisionAdditionButton,
            provisionTagListView,
            mbtiLabel,
            mbtiTextField,
            doubleCheckButton,
            ageRangeLabel,
            introduceLabel,
            introduceTextField,
            signUpButton
        ].forEach {
            contentView.addSubview($0)
        }
        genderCheckBoxViews[0].check()
        genderCheckBoxViews.forEach {
            genderStackView.addArrangedSubview($0)
        }
        
        nationalityCheckBoxViews[0].check()
        nationalityCheckBoxViews.forEach {
            nationalityStackView.addArrangedSubview($0)
        }
    }
    
    private func setupNavigationBar() {
        title = SYText.signup
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Palette.gray1000]
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureScrollView()
        configureContentView()
        configureTitleLabel()
        configurePasswordLabel()
        configurePasswordTextField()
        configurePasswordErrorLabel()
        configureNicknameLabel()
        configureNicknameTextField()
        configureNicknameErrorLabel()
        configureDoubleCheckButton()
        configureBirthDateLabel()
        configureBirthDateTextField()
        configureBirthDateErrorLabel()
        configureAgeRangeLabel()
        configureGenderLabel()
        configureGenderStackView()
        configureNationalityLabel()
        configureNationalityStackView()
        configurePeriodLabel()
        configureYearLabel()
        configurePeriodTextField()
        configureLevelLabel()
        configureLevelSliderView()
        configureActiveAreaLabel()
        configureActiveAreaAdditionButton()
        configureActiveAreaTagListView()
        configureProvisionLabel()
        configureProvisionAdditionButton()
        configureProvisionTagListView()
        configureMBTILabel()
        configureMBTITextField()
        configureIntroduceLabel()
        configureIntroduceTextField()
        configureSignUpButton()
    }
    
    private func configureScrollView() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureContentView() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.TitleLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TitleLabel.leadingMargin)
        }
    }
    
    private func configurePasswordLabel() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.PasswordLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.PasswordLabel.leadingMargin)
        }
    }
    
    private func configurePasswordTextField() {
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(Constants.PasswordTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.PasswordTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.PasswordTextField.trailingMargin)
            $0.height.equalTo(Constants.PasswordTextField.height)
        }
    }
    
    private func configurePasswordErrorLabel() {
        passwordErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Constants.PasswordErrorLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.PasswordErrorLabel.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.PasswordErrorLabel.trailingMargin)
        }
    }
    
    private func configureNicknameLabel() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(Constants.NickNameLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.NickNameLabel.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.NickNameLabel.trailingMargin)
        }
    }
    
    private func configureNicknameTextField() {
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Constants.NickNameTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.NickNameTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.NickNameTextField.trailingMargin)
            $0.height.equalTo(Constants.NickNameTextField.height)
        }
    }
    
    private func configureNicknameErrorLabel() {
        nicknameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(Constants.NickNameErrorLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.NickNameErrorLabel.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.NickNameErrorLabel.trailingMargin)
        }
    }
    
    private func configureDoubleCheckButton() {
        doubleCheckButton.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.top).offset(Constants.DoubleCheckButton.topMargin)
            $0.trailing.equalTo(nicknameTextField.snp.trailing).offset(Constants.DoubleCheckButton.trailingMargin)
            $0.bottom.equalTo(nicknameTextField.snp.bottom).offset(Constants.DoubleCheckButton.bottomMargin)
            $0.width.equalTo(Constants.DoubleCheckButton.width)
        }
    }
    
    private func configureBirthDateLabel() {
        birthDateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(Constants.BirthDateLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.BirthDateLabel.leadingMargin)
        }
    }
    
    private func configureBirthDateTextField() {
        birthDateTextField.snp.makeConstraints {
            $0.top.equalTo(birthDateLabel.snp.bottom).offset(Constants.BirthDateTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.BirthDateTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.BirthDateTextField.trailingMargin)
            $0.height.equalTo(Constants.BirthDateTextField.height)
        }
    }
    
    private func configureBirthDateErrorLabel() {
        birthDateErrorLabel.snp.makeConstraints {
            $0.top.equalTo(birthDateTextField.snp.bottom).offset(Constants.BirthDateErrorLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.BirthDateErrorLabel.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.BirthDateErrorLabel.trailingMargin)
        }
    }
    
    private func configureAgeRangeLabel() {
        ageRangeLabel.snp.makeConstraints {
            $0.top.equalTo(birthDateTextField.snp.top).offset(Constants.AgeRangeLabel.topMargin)
            $0.trailing.equalTo(birthDateTextField.snp.trailing).offset(Constants.AgeRangeLabel.trailingMargin)
            $0.bottom.equalTo(birthDateTextField.snp.bottom).offset(Constants.AgeRangeLabel.bottomMargin)
            $0.width.greaterThanOrEqualTo(Constants.AgeRangeLabel.width)
        }
    }
    
    private func configureGenderLabel() {
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(birthDateTextField.snp.bottom).offset(Constants.GenderLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.GenderLabel.leadingMargin)
        }
    }
    
    private func configureGenderStackView() {
        genderStackView.snp.makeConstraints {
            $0.top.equalTo(genderLabel.snp.bottom).offset(Constants.GenderStackView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.GenderStackView.leadingMargin)
            $0.width.equalTo(Constants.GenderStackView.width)
            $0.height.equalTo(Constants.GenderStackView.height)
        }
    }
    
    private func configureNationalityLabel() {
        nationalityLabel.snp.makeConstraints {
            $0.top.equalTo(genderStackView.snp.bottom).offset(Constants.NationalityLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.NationalityLabel.leadingMargin)
        }
    }
    
    private func configureNationalityStackView() {
        nationalityStackView.snp.makeConstraints {
            $0.top.equalTo(nationalityLabel.snp.bottom).offset(Constants.NationalityStackView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.NationalityStackView.leadingMargin)
            $0.width.equalTo(Constants.NationalityStackView.width)
            $0.height.equalTo(Constants.NationalityStackView.height)
        }
    }
    
    private func configurePeriodLabel() {
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(nationalityStackView.snp.bottom).offset(Constants.PeriodLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.PeriodLabel.leadingMargin)
        }
    }
    
    private func configureYearLabel() {
        yearLabel.snp.makeConstraints {
            $0.centerY.equalTo(periodTextField)
            $0.trailing.equalTo(periodTextField.snp.trailing).offset(Constants.YearLabel.trailingMargin)
        }
    }
    
    private func configurePeriodTextField() {
        periodTextField.snp.makeConstraints {
            $0.top.equalTo(periodLabel.snp.bottom).offset(Constants.PeriodTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.PeriodTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.PeriodTextField.trailingMargin)
            $0.height.equalTo(Constants.PeriodTextField.height)
        }
    }
    
    private func configureLevelLabel() {
        levelLabel.snp.makeConstraints {
            $0.top.equalTo(periodTextField.snp.bottom).offset(Constants.LevelLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.LevelLabel.leadingMargin)
        }
    }
    
    private func configureLevelSliderView() {
        levelSliderView.snp.makeConstraints {
            $0.top.equalTo(levelLabel.snp.bottom).offset(Constants.LevelSliderView.topMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.LevelSliderView.height)
        }
    }
    
    private func configureActiveAreaLabel() {
        activeAreaLabel.snp.makeConstraints {
            $0.top.equalTo(levelSliderView.snp.bottom).offset(Constants.ActiveArea.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ActiveArea.leadingMargin)
        }
    }
    
    private func configureActiveAreaAdditionButton() {
        activeAreaAdditionButton.snp.makeConstraints {
            $0.centerY.equalTo(activeAreaLabel)
            $0.trailing.equalToSuperview().offset(Constants.ActiveAreaAdditionButton.trailingMargin)
            $0.width.equalTo(Constants.ActiveAreaAdditionButton.width)
            $0.height.equalTo(Constants.ActiveAreaAdditionButton.height)
        }
    }
    
    private func configureActiveAreaTagListView() {
        activeAreaTagListView.snp.makeConstraints {
            $0.top.equalTo(activeAreaLabel.snp.bottom).offset(Constants.ActiveAreaTagListView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ActiveAreaTagListView.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.ActiveAreaTagListView.trailingMargin)
            $0.height.greaterThanOrEqualTo(Constants.ActiveAreaTagListView.minHeight)
        }
    }
    
    private func configureProvisionLabel() {
        provisionLabel.snp.makeConstraints {
            $0.top.equalTo(activeAreaTagListView.snp.bottom).offset(Constants.ProvisionLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ProvisionLabel.leadingMargin)
        }
    }
    
    private func configureProvisionAdditionButton() {
        provisionAdditionButton.snp.makeConstraints {
            $0.centerY.equalTo(provisionLabel)
            $0.trailing.equalToSuperview().offset(Constants.ProvisionAdditionButton.trailingMargin)
            $0.width.equalTo(Constants.ProvisionAdditionButton.width)
            $0.height.equalTo(Constants.ProvisionAdditionButton.height)
        }
    }
    
    private func configureProvisionTagListView() {
        provisionTagListView.snp.makeConstraints {
            $0.top.equalTo(provisionLabel.snp.bottom).offset(Constants.ProvisionTagListView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.ProvisionTagListView.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.ProvisionTagListView.trailingMargin)
            $0.height.greaterThanOrEqualTo(Constants.ProvisionTagListView.minHeight)
        }
    }
    
    private func configureMBTILabel() {
        mbtiLabel.snp.makeConstraints {
            $0.top.equalTo(provisionTagListView.snp.bottom).offset(Constants.MBTILabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.MBTILabel.leadingMargin)
        }
    }
    
    private func configureMBTITextField() {
        mbtiTextField.snp.makeConstraints {
            $0.top.equalTo(mbtiLabel.snp.bottom).offset(Constants.MBTITextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.MBTITextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.MBTITextField.trailingMargin)
            $0.height.equalTo(Constants.MBTITextField.height)
        }
    }
    
    private func configureIntroduceLabel() {
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(mbtiTextField.snp.bottom).offset(Constants.IntroduceLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.IntroduceLabel.leadingMargin)
        }
    }
    
    private func configureIntroduceTextField() {
        introduceTextField.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(Constants.IntroduceTextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.IntroduceTextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.IntroduceTextField.trailingMargin)
            $0.height.equalTo(Constants.IntroduceTextField.height)
        }
    }
    
    private func configureSignUpButton() {
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(introduceTextField.snp.bottom).offset(Constants.SignUpButton.topMargin)
            $0.leading.equalToSuperview().offset(Constants.SignUpButton.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.SignUpButton.trailingMargin)
            $0.bottom.equalToSuperview().offset(Constants.SignUpButton.bottomMargin)
            $0.height.equalTo(Constants.SignUpButton.height)
        }
    }
}
