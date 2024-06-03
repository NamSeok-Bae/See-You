//
//  SignUpBottomSheetVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

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
        button.setBackgroundColor(.Palette.primary500, for: .normal)
        button.setBackgroundColor(.Palette.primary500.withAlphaComponent(0.4), for: .disabled)
        button.clipsToBounds = true
        button.layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        button.setTitle(SYText.agree_and_continue, for: .normal)
        button.setTitleColor(.Palette.gray0, for: .normal)
        button.isEnabled = false
        
        return button
    }()
    
    private let checkBoxViews: [CheckBoxView] = [
        CheckBoxView(text: SYText.terms_of_age, underLine: false),
        CheckBoxView(text: SYText.terms_of_service, underLine: true),
        CheckBoxView(text: SYText.terms_of_information, underLine: true),
        CheckBoxView(text: SYText.terms_of_marketing, underLine: true)
    ]
    
    // MARK: - Properties
    private var checkBoxTagArray = Array(repeating: false, count: 5)
    private let viewModel: SignUpBottomSheetVM
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycles
    init(viewModel: SignUpBottomSheetVM) {
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
        configureUI()
    }
    
    // MARK: - Helpers
    private func bind() {
        let input = SignUpBottomSheetVM.Input(
            continueButtonDidTapped: continueButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        dimmedView
            .rx
            .tapGesture()
            .when(.recognized)
            .map { _ in }
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        rightBarItem
            .rx
            .tap
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
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
            static let height: CGFloat = .toScaledHeight(value: 26)
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
        
        setupCheckBoxView()
    }
    
    private func setupCheckBoxView() {
        var tag = 1
        checkBoxViews.map {
            $0.tag = tag
            tag += 1
            $0.delegate = self
            return $0
        }.forEach {
            stackView.addArrangedSubview($0)
        }
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
            $0.height.equalTo(Constants.LeftBarItem.height)
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

extension SignUpBottomSheetVC: CheckBoxViewDelegate {
    private func presentTermOfUsePage(_ tag: Int) {
        print("\(tag)에 관한 이용 약관 동의 창 열기")
    }
    
    func validateButtonTags(_ tag: Int) {
        checkBoxTagArray[tag] = !checkBoxTagArray[tag]
        
        for i in 1...3 {
            if checkBoxTagArray[i] == false {
                continueButton.isEnabled = false
                return
            }
        }
        continueButton.isEnabled = true
    }
    
    func touchUpLabelButton(_ tag: Int) {
        if tag != 1 { presentTermOfUsePage(tag) }
    }
}
