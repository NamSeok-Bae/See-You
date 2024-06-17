//
//  OptionSelectViewController.swift
//  SeeYou
//
//  Created by 배남석 on 6/13/24.
//

import UIKit
import SnapKit
import TagListView
import RxSwift
import RxKeyboard

// TODO: 스크롤 뷰로 해야할 거 같은데?

class OptionSelectVC: UIViewController {
    // MARK: - UI properties
    private lazy var multiplyButton = UIBarButtonItem(
        image: .multiply,
        style: .plain,
        target: self,
        action: nil
    )
    
    private lazy var textField: UITextField = {
        let textField = CommonTextField(placeholder: type.toPlaceholder())
        textField.delegate = self
        
        return textField
    }()
    
    private let additionButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.Palette.primary500, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var frequentlyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .Palette.gray1000
        label.sizeToFit()
        label.text = type.toLabelText()
        
        return label
    }()
    
    private lazy var tagListView: TagListView = {
        let view = TagListView()
        view.tagBackgroundColor = .Palette.gray0
        view.textColor = .Palette.gray1000
        view.borderColor = .Palette.gray200
        view.borderWidth = 1
        view.cornerRadius = 14
        view.paddingX = 16
        view.paddingY = 8
        view.marginX = 8
        view.marginY = 8
        view.selectedBorderColor = .Palette.red500
        view.selectedTextColor = .Palette.primary500
        view.textFont = .systemFont(ofSize: 14)
        view.delegate = self
        
        return view
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .Palette.gray100
        
        return view
    }()
    
    private lazy var selectedOptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .Palette.gray1000
        label.sizeToFit()
        label.text = type.toSelecetedLabelText()
        
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .light)
        let image = UIImage.go_forward?
            .withConfiguration(imageConfig)
            .withTintColor(.Palette.gray1000, renderingMode: .alwaysOriginal)
        let disableImage = UIImage.go_forward?
            .withConfiguration(imageConfig)
            .withTintColor(.Palette.gray1000.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        
        button.setTitle("초기화", for: .normal)
        button.setImage(image, for: .normal)
        button.setImage(disableImage, for: .disabled)
        button.setTitleColor(.Palette.gray1000, for: .normal)
        button.setTitleColor(.Palette.gray1000.withAlphaComponent(0.4), for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var selectedPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = type.toPlaceholder()
        label.textColor = .Palette.gray500
        label.sizeToFit()
        label.font = .systemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var selectedTagListView: TagListView = {
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
    
    private let completeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle("선택완료", for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        
        return button
    }()
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let type: OptionType
    private let viewModel: OptionSelectVM
    private var selectedTagList: [String] = [] {
        didSet {
            self.selectedPlaceholderLabel.isHidden = selectedTagList.count > 0
            self.resetButton.isEnabled = true
        }
    }
    
    // MARK: - Lifecycles
    init(viewModel: OptionSelectVM, type: OptionType) {
        self.viewModel = viewModel
        self.type = type
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
        let input = OptionSelectVM.Input(
            multiplyButtonDidTapped: multiplyButton.rx.tap.asObservable(),
            completeButtonDidTapped:
                completeButton.rx.tap.map { _ in self.selectedTagList }.asObservable())
        
        let _ = viewModel.transform(input: input)
        
        tagListView.addTags(["잠실/송리단길", "강남", "이태원/경리단길", "성수동", "신사동", "홍대", "한남동", "서촌", "연남동"])
        
        additionButton.rx
            .tap
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                if let text = textField.text {
                    if !selectedTagList.contains(text) {
                        selectedTagList.append(text)
                        selectedTagListView.addTag(text)
                    } else {
                        showToast(type: .alreadySelect)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        resetButton.rx
            .tap
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                selectedTagList = []
                selectedTagListView.removeAllTags()
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(onNext: { keyboardVisibleHeight in
                UIView.animate(withDuration: 0.5) { [weak self] in
                    guard let self else { return }
                    completeButton.snp.updateConstraints {
                        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardVisibleHeight)
                    }
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextField Delegate
extension OptionSelectVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.tintColor = .Palette.primary500
        return true
    }
}

// MARK: - TagListView Delegate
extension OptionSelectVC: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
        if sender == self.tagListView {
            tagView.isSelected = !tagView.isSelected
            
            sender.tagViews.filter { $0 != tagView }.forEach { $0.isSelected = false }
            
            if !self.selectedTagList.contains(title) {
                self.selectedTagList.append(title)
                self.selectedTagListView.addTag(title)
            } else {
                self.showToast(type: .alreadySelect)
            }
        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
}

// MARK: - Setup & Configure UI
extension OptionSelectVC {
    enum Constants {
        enum TextField {
            static let topMargin: CGFloat = .toScaledHeight(value: 24)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
        
        enum AdditionButton {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -16)
            static let height: CGFloat = .toScaledHeight(value: 22)
            static let width: CGFloat = .toScaledWidth(value: 30)
        }
        
        enum FrequentlyLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 24)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum TagListView {
            static let topMargin: CGFloat = .toScaledHeight(value: 12)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let minHeight: CGFloat = .toScaledHeight(value: 36)
        }
        
        enum DimmedView {
            static let bottomMargin: CGFloat = .toScaledHeight(value: -16)
            static let minHeight: CGFloat = .toScaledHeight(value: 108)
        }
        
        enum SelectedOptionLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 20)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum ResetButton {
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let height: CGFloat = .toScaledHeight(value: 20)
            static let width: CGFloat = .toScaledWidth(value: 59)
        }
        
        enum SelectedPlaceholderLabel {
            static let topMargin: CGFloat = .toScaledHeight(value: 12)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
        }
        
        enum SelectedTagListView {
            static let topMargin: CGFloat = .toScaledHeight(value: 12)
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -20)
            static let minHeight: CGFloat = .toScaledHeight(value: 36)
        }
        
        enum CompleteButton {
            static let leadingMargin: CGFloat = .toScaledWidth(value: 20)
            static let trailingMargin: CGFloat = .toScaledWidth(value: -20)
            static let bottomMargin: CGFloat = .toScaledHeight(value: -16)
            static let height: CGFloat = .toScaledHeight(value: 48)
        }
    }
    
    private func setupViews() {
        [
            textField,
            additionButton,
            frequentlyLabel,
            tagListView,
            dimmedView,
            completeButton
        ].forEach {
            view.addSubview($0)
        }
        
        [
            selectedOptionLabel,
            resetButton,
            selectedPlaceholderLabel,
            selectedTagListView
        ].forEach {
            dimmedView.addSubview($0)
        }
    }
    
    private func setupNavigationBar() {
        title = type.toName()
        navigationItem.rightBarButtonItem = multiplyButton
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    private func configureUI() {
        view.backgroundColor = .Palette.gray0
        
        configureTextField()
        configureAdditionButton()
        configureFrequentlyLabel()
        configureTagListView()
        configureDimmedView()
        configureSelectedOptionLabel()
        configureResetButton()
        configureSelectedPlaceholderLabel()
        configureSelectedTagListView()
        configureCompleteButton()
    }
    
    private func configureTextField() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.TextField.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TextField.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.TextField.trailingMargin)
            $0.height.equalTo(Constants.TextField.height)
        }
    }
    
    private func configureAdditionButton() {
        additionButton.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(textField.snp.trailing).offset(Constants.AdditionButton.trailingMargin)
            $0.height.equalTo(Constants.AdditionButton.height)
            $0.width.equalTo(Constants.AdditionButton.width)
        }
    }
    
    private func configureFrequentlyLabel() {
        frequentlyLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(Constants.FrequentlyLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.FrequentlyLabel.leadingMargin)
        }
    }
    
    private func configureTagListView() {
        tagListView.snp.makeConstraints {
            $0.top.equalTo(frequentlyLabel.snp.bottom).offset(Constants.TagListView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.TagListView.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.TagListView.trailingMargin)
            $0.height.greaterThanOrEqualTo(Constants.TagListView.minHeight)
        }
    }
    
    private func configureDimmedView() {
        dimmedView.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(Constants.DimmedView.bottomMargin)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(Constants.DimmedView.minHeight)
        }
    }
    
    private func configureSelectedOptionLabel() {
        selectedOptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.SelectedOptionLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.SelectedOptionLabel.leadingMargin)
        }
    }
    
    private func configureResetButton() {
        resetButton.snp.makeConstraints {
            $0.centerY.equalTo(selectedOptionLabel)
            $0.trailing.equalToSuperview().offset(Constants.ResetButton.trailingMargin)
            $0.height.equalTo(Constants.ResetButton.height)
            $0.width.equalTo(Constants.ResetButton.width)
        }
    }
    
    private func configureSelectedPlaceholderLabel() {
        selectedPlaceholderLabel.snp.makeConstraints {
            $0.top.equalTo(selectedOptionLabel.snp.bottom).offset(Constants.SelectedPlaceholderLabel.topMargin)
            $0.leading.equalToSuperview().offset(Constants.SelectedPlaceholderLabel.leadingMargin)
        }
    }
    
    private func configureSelectedTagListView() {
        selectedTagListView.snp.makeConstraints {
            $0.top.equalTo(selectedOptionLabel.snp.bottom).offset(Constants.SelectedTagListView.topMargin)
            $0.leading.equalToSuperview().offset(Constants.SelectedTagListView.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.SelectedTagListView.trailingMargin)
            $0.bottom.equalToSuperview().offset(Constants.SelectedTagListView.bottomMargin)
            $0.height.greaterThanOrEqualTo(Constants.SelectedTagListView.minHeight)
        }
    }
    
    private func configureCompleteButton() {
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(Constants.CompleteButton.bottomMargin)
            $0.leading.equalToSuperview().offset(Constants.CompleteButton.leadingMargin)
            $0.trailing.equalToSuperview().offset(Constants.CompleteButton.trailingMargin)
            $0.height.equalTo(Constants.CompleteButton.height)
        }
    }
}
