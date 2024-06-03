//
//  LoginCooridnator.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import UIKit
import RxSwift

final class DefaultLoginCooridnator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginViewController()
    }
    
    private func didFinishedAuth() {
        if let vc = self.navigationController.viewControllers.first {
            self.navigationController.viewControllers = [vc]
        }
        self.navigationController.tabBarController?.selectedIndex = 0
    }
    
    private func showLoginViewController() {
        let useCase = DefaultLoginUseCase()
        let vm = LoginVM(useCase: useCase)
        let vc = LoginVC(viewModel: vm)
        
        vm.multiplyButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                didFinishedAuth()
            })
            .disposed(by: disposeBag)
        
        vm.signUpButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                showSignUpViewController()
            })
            .disposed(by: disposeBag)
        
        navigationController.viewControllers = [vc]
    }
    
    private func showSignUpViewController() {
        let useCase = DefaultSignUpUseCase()
        let vm = SignUpVM(useCase: useCase)
        let vc = SignUpVC(viewModel: vm)
        
        vm.multiplyButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                didFinishedAuth()
            })
            .disposed(by: disposeBag)
        
        vm.signUpCustomerViewDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                showSignUpBottomSheetVC(.customer)
            })
            .disposed(by: disposeBag)
        
        vm.signUpGuideViewDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                showSignUpBottomSheetVC(.guide)
            })
            .disposed(by: disposeBag)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showSignUpBottomSheetVC(_ signUpType: SignUpType) {
        let vm = SignUpBottomSheetVM()
        let vc = SignUpBottomSheetVC(viewModel: vm)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        
        vm.continueButtonDidTapped
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                navigationController.dismiss(animated: false) {
                    self.showSignUpEmailConfirmVC(signUpType)
                }
            })
            .disposed(by: disposeBag)
        
        self.navigationController.topViewController?.present(vc, animated: true)
    }
    
    private func showSignUpEmailConfirmVC(_ signUpType: SignUpType) {
        let vm = SignUpEmailConfirmVM(useCase: DefaultSignUpUseCase())
        let vc = SignUpEmailConfirmVC(viewModel: vm)
        
        vm.multiplyButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                didFinishedAuth()
            })
            .disposed(by: disposeBag)
        
        vm.confirmButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                showSignUpInfomationVC(signUpType: signUpType)
            })
            .disposed(by: disposeBag)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showSignUpInfomationVC(signUpType: SignUpType) {
        
    }
}
