//
//  OptionSelectVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/13/24.
//

import UIKit
import RxSwift
import RxRelay

final class OptionSelectVM {
    // MARK: - Input
    struct Input {
        var multiplyButtonDidTapped: Observable<Void>
        var completeButtonDidTapped: Observable<[String]>
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Dependency
    private let disposeBag = DisposeBag()
//    private let useCase:
    var multiplyButtonDidTapped = PublishRelay<Void>()
    var completeButtonDidTapped = PublishRelay<[String]>()
    
    // MARK: - LifeCycle
//    init(useCase: SignUpUseCase) {
//        self.useCase = useCase
//    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.multiplyButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                multiplyButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.completeButtonDidTapped
            .subscribe(onNext: { [weak self] texts in
                guard let self else { return }
                completeButtonDidTapped.accept(texts)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
