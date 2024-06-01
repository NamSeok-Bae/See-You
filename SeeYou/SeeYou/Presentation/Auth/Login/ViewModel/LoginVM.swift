//
//  LoginVM.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation
import RxSwift

final class LoginVM {
    // MARK: - Input
    struct Input {
        
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Dependency
    private var disposeBag = DisposeBag()
    private let useCase: LoginUseCase
    
    // MARK: - LifeCycle
    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
