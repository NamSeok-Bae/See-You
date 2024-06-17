//
//  SignUpCustomerInfomationVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/9/24.
//

import UIKit
import RxSwift
import RxRelay

final class SignUpCustomerInformationVM {
    // MARK: - Input
    struct Input {
        var passwordTextFieldChanged: Observable<String>
        var birthDateTextFieldChanged: Observable<String>
        var doubleCheckButtonDidTapped: Observable<String>
        var genderSelected: Observable<Int>
        var nationalitySelected: Observable<Int>
        var signUpButtonDidTapped: Observable<CustomerInfo>
    }
    
    // MARK: - Output
    struct Output {
        var isValidatePassword = PublishRelay<Bool>()
        var AgeRangeText = PublishRelay<String>()
        var doubleChecked = PublishRelay<Bool>()
        var essentialFilled = PublishRelay<Bool>()
    }
    
    // MARK: - Dependency
    private let disposeBag = DisposeBag()
//    private let useCase:
    var signUpButtonDidTapped = PublishRelay<Void>()
    
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
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                // TODO: 닉네임 중복 API 연동
                if validateNickname(text) {
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
                    output.AgeRangeText.accept("\(diff)대")
                } else {
                    output.AgeRangeText.accept("")
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
        
        Observable.combineLatest(
            output.isValidatePassword.asObservable(),
            output.doubleChecked.asObservable(),
            output.AgeRangeText.asObservable(),
            input.genderSelected.asObservable(),
            input.nationalitySelected.asObservable(),
            resultSelector: { (
                isValidatePassword: Bool,
                doubleChecked: Bool,
                ageRangeText: String,
                genderSelected: Int,
                nationalitySelected: Int) in
                return (isValidatePassword, doubleChecked, ageRangeText, genderSelected, nationalitySelected)
            }
        ).subscribe(onNext: { event in
            if event.0 && event.1 && event.2 != "" {
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
    
    private func validateNickname(_ input: String) -> Bool {
        return input.count >= 2 && input.count <= 24
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
}
