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
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Dependency
    private var disposeBag = DisposeBag()
    private let useCase: SignUpUseCase
    var multiplyButtonDidTapped = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
