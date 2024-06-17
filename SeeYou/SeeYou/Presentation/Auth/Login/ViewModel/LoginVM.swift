//
//  LoginVM.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation
import RxSwift
import RxRelay

final class LoginVM {
    // MARK: - Input
    struct Input {
        var multiplyButtonDidTapped: Observable<Void>
        var loginButtonDidTapped: Observable<(String, String)>
        var signUpButtonDidTapped: Observable<Void>
        var passwordResetButtonDidTapped: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        var isValidateLogin = PublishRelay<Bool>()
    }
    
    // MARK: - Dependency
    private var disposeBag = DisposeBag()
    private let useCase: LoginUseCase
    var multiplyButtonDidTapped = PublishRelay<Void>()
    var signUpButtonDidTapped = PublishRelay<Void>()
    var passwordResetButtonDidTapped = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.multiplyButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.multiplyButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.loginButtonDidTapped
            .subscribe(onNext: { [weak self] email, password in
                guard let self else { return }
                
                // TODO: 로그인 api 연동하기
                output.isValidateLogin.accept(validateEmail(email) && validatePassword(password))
            })
            .disposed(by: disposeBag)
        
        input.signUpButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.signUpButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.passwordResetButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.passwordResetButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    private func validateEmail(_ input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = emailPredicate.evaluate(with: input)

        return isValid
    }
    
    private func validatePassword(_ input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,30}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)
        
        return isValid
    }
}
