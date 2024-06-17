//
//  SignUpGuideInformationVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/13/24.
//

import UIKit
import RxSwift
import RxRelay

final class SignUpGuideInformationVM {
    // MARK: - Input
    struct Input {
        var passwordTextFieldChanged: Observable<String>
        var birthDateTextFieldChanged: Observable<String>
        var doubleCheckButtonDidTapped: Observable<String>
        var genderSelected: Observable<Int>
        var nationalitySelected: Observable<Int>
        var signUpButtonDidTapped: Observable<CustomerInfo>
        var activeAreaAdditionButtonDidTapped: Observable<Void>
        var activeAreaTagDidRemoved: Observable<String>
        var provisionAdditionButtonDidTapped: Observable<Void>
        var provisionTagDidRemoved: Observable<String>
    }
    
    // MARK: - Output
    struct Output {
        var isValidatePassword = PublishRelay<Bool>()
        var ageRangeText = PublishRelay<String>()
        var doubleChecked = PublishRelay<Bool>()
        var essentialFilled = PublishRelay<Bool>()
        var activeAreaTagSelected = PublishRelay<[String]>()
        var provisionTagSelected = PublishRelay<[String]>()
    }
    
    // MARK: - Dependency
    private let disposeBag = DisposeBag()
//    private let useCase:
    var signUpButtonDidTapped = PublishRelay<Void>()
    var activeAreaAdditionButtonDidTapped = PublishRelay<Void>()
    var provisionAdditionButtonDidTapped = PublishRelay<Void>()
    var activeAreaTagSelected = PublishRelay<[String]>()
    var provisionTagSelected = PublishRelay<[String]>()
    private var currentActiveAreaTagList = BehaviorRelay<[String]>(value: [])
    private var currentProvisionTagList = BehaviorRelay<[String]>(value: [])
    
    // MARK: - LifeCycle
//    init(useCase: SignUpUseCase) {
//        self.useCase = useCase
//    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.passwordTextFieldChanged
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                output.isValidatePassword.accept(validatePassword(text))
            })
            .disposed(by: disposeBag)
        
        input.doubleCheckButtonDidTapped
            .subscribe(onNext: { text in
                // TODO: 닉네임 중복 API 연동
                if text != "" {
                    output.doubleChecked.accept(true)
                } else {
                    output.doubleChecked.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.birthDateTextFieldChanged
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                if validateBirthDate(text) {
                    let diff = calculateDateDiff(text)
                    output.ageRangeText.accept("\(diff)대")
                } else {
                    output.ageRangeText.accept("")
                }
            })
            .disposed(by: disposeBag)
        
        input.signUpButtonDidTapped
            .subscribe(onNext: { [weak self] customerInfo in
                guard let self else { return }
                // 유저정보 입력 후 가입 API 연동
                signUpButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.activeAreaAdditionButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                activeAreaAdditionButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.activeAreaTagDidRemoved
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                let newList = currentActiveAreaTagList.value.filter { $0 != text }
                currentActiveAreaTagList.accept(newList)
            })
            .disposed(by: disposeBag)
        
        input.provisionAdditionButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                provisionAdditionButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.provisionTagDidRemoved
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                let newList = currentProvisionTagList.value.filter { $0 != text }
                currentProvisionTagList.accept(newList)
            })
            .disposed(by: disposeBag)
        
        activeAreaTagSelected
            .subscribe(onNext: { [weak self] texts in
                guard let self else { return }
                let newTexts = removeDuplicate(oldTexts: currentActiveAreaTagList.value, newTexts: texts)
                currentActiveAreaTagList.accept(newTexts)
                output.activeAreaTagSelected.accept(newTexts)
            })
            .disposed(by: disposeBag)
        
        provisionTagSelected
            .subscribe(onNext: { [weak self] texts in
                guard let self else { return }
                let newTexts = removeDuplicate(oldTexts: currentProvisionTagList.value, newTexts: texts)
                currentProvisionTagList.accept(newTexts)
                output.provisionTagSelected.accept(newTexts)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            output.isValidatePassword.asObservable(),
            output.doubleChecked.asObservable(),
            output.ageRangeText.asObservable(),
            input.genderSelected.asObservable(),
            input.nationalitySelected.asObservable(),
            currentActiveAreaTagList,
            currentProvisionTagList,
            resultSelector: { (
                isValidatePassword: Bool,
                doubleChecked: Bool,
                ageRangeText: String,
                genderSelected: Int,
                nationalitySelected: Int,
                activeAreaTagList: [String],
                provisionTagList: [String]) in
                return (
                    isValidatePassword, doubleChecked, ageRangeText,
                    genderSelected, nationalitySelected,
                    activeAreaTagList, provisionTagList)
            }
        ).subscribe(onNext: { event in
            if event.0 && event.1 && event.2 != "" && event.5.count != 0 && event.6.count != 0 {
                output.essentialFilled.accept(true)
            } else {
                output.essentialFilled.accept(false)
            }
        })
        .disposed(by: disposeBag)
        
        return output
    }
    
    private func calculateDateDiff(_ text: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        let convertDate = dateFormatter.string(from: Date())
        let newText = text.prefix(2).map { String($0) }.joined()
        let result = (100 + Int(convertDate)! - Int(newText)!) / 10
        
        return result * 10
    }
    
    private func validatePassword(_ input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,30}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)
        
        return isValid
    }
    
    private func validateBirthDate(_ input: String) -> Bool {
        let regex = "[0-9]{2}(0[1-9]|1[0-2])(0[1-9]|[1,2][0-9]|3[0,1])"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)

        return isValid
    }
    
    private func removeDuplicate(oldTexts: [String], newTexts: [String]) -> [String] {
        var result: [String] = oldTexts
        result.append(contentsOf: newTexts.filter { !oldTexts.contains($0) })
        
        return result
    }
}
