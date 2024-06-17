//
//  SignUpVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/1/24.
//

import Foundation
import RxSwift
import RxRelay

final class SignUpVM {
    // MARK: - Input
    struct Input {
        var multiplyButtonDidTapped: Observable<Void>
        var signUpCustomerViewDidTapped: Observable<Void>
        var signUpGuideViewDidTapped: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Dependency
    private var disposeBag = DisposeBag()
    private let useCase: SignUpUseCase
    var multiplyButtonDidTapped = PublishRelay<Void>()
    var signUpCustomerViewDidTapped = PublishRelay<Void>()
    var signUpGuideViewDidTapped = PublishRelay<Void>()
    
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
        
        input.signUpCustomerViewDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                signUpCustomerViewDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.signUpGuideViewDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                signUpGuideViewDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
