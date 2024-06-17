//
//  SignUpEmailConfirmVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/2/24.
//

import Foundation
import RxSwift
import RxRelay

final class SignUpEmailConfirmVM {
    // MARK: - Input
    struct Input {
        var multiplyButtonDidTapped: Observable<Void>
        var temporaryCodeButtonDidTapped: Observable<String>
        var confirmButtonDidTapped: Observable<String>
    }
    
    // MARK: - Output
    struct Output {
        var isValidateTemporaryCode = PublishRelay<Bool>()
        var isValidateConfirm = PublishRelay<Bool>()
    }
    
    // MARK: - Dependency
    private let disposeBag = DisposeBag()
    private let useCase: SignUpUseCase
    var multiplyButtonDidTapped = PublishRelay<Void>()
    var confirmButtonDidTapped = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    init(useCase: SignUpUseCase) {
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
        
        input.temporaryCodeButtonDidTapped
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                output.isValidateTemporaryCode.accept(validateEmail(text))
            })
            .disposed(by: disposeBag)
        
        input.confirmButtonDidTapped
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                // TODO: 인증번호 인증 API 연동
                self.confirmButtonDidTapped.accept(())
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
}
