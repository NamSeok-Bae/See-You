//
//  SignUpBottomSheetVM.swift
//  SeeYou
//
//  Created by 배남석 on 6/1/24.
//

import Foundation
import RxSwift
import RxRelay

final class SignUpBottomSheetVM {
    // MARK: - Input
    struct Input {
        var continueButtonDidTapped: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - Dependency
    private var disposeBag = DisposeBag()
    var continueButtonDidTapped = PublishRelay<Void>()
    
    // MARK: - LifeCycle
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.continueButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                continueButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
