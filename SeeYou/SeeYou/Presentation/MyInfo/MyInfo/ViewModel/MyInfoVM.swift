//
//  MyInfoVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/1/24.
//

import Foundation
import RxSwift
import RxRelay

final class MyInfoVM {
    // MARK: - Input
    struct Input {
    }
    
    // MARK: - Output
    struct Output {
    }
    
    // MARK: - Dependency
    private var disposeBag = DisposeBag()
    private let useCase: MyInfoUseCase
    
    // MARK: - LifeCycle
    init(useCase: MyInfoUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
