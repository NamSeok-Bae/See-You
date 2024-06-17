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
        self.navigationController.tabBarController?.tabBar.isHidden = false
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
        
        navigationController.pushViewController(vc, animated: false)
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
        if signUpType == .customer {
            let vm = SignUpCustomerInformationVM()
            let vc = SignUpCustomerInfomationVC(viewModel: vm)
            
            vm.signUpButtonDidTapped
                .subscribe(onNext: { [weak self] in
                    guard let self else { return }
                    showSignUpSuccessVC(signUpType: signUpType)
                })
                .disposed(by: disposeBag)
            
            self.navigationController.pushViewController(vc, animated: true)
        } else if signUpType == .guide {
            let vm = SignUpGuideInformationVM()
            let vc = SignUpGuideInformationVC(viewModel: vm)
            
            vm.signUpButtonDidTapped
                .subscribe(onNext: { [weak self] in
                    guard let self else { return }
                    showSignUpSuccessVC(signUpType: signUpType)
                })
                .disposed(by: disposeBag)
            
            vm.activeAreaAdditionButtonDidTapped
                .subscribe(onNext: { [weak self] in
                    guard let self else { return }
                    showOptionSelectVC(parentVM: vm, type: .activeArea)
                })
                .disposed(by: disposeBag)
            
            vm.provisionAdditionButtonDidTapped
                .subscribe(onNext: { [weak self] in
                    guard let self else { return }
                    showOptionSelectVC(parentVM: vm, type: .provision)
                })
                .disposed(by: disposeBag)
            
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    private func showSignUpSuccessVC(signUpType: SignUpType) {
        if signUpType == .customer {
            let vc = SignUpCustomerSuccessVC()
            vc.modalPresentationStyle = .fullScreen
            
            self.navigationController.present(vc, animated: true)
        } else if signUpType == .guide {
            let vc = SignUpCustomerSuccessVC()
            vc.modalPresentationStyle = .fullScreen
            
            self.navigationController.present(vc, animated: true)
        }
    }
    
    private func showOptionSelectVC(parentVM: SignUpGuideInformationVM, type: OptionType) {
        let vm = OptionSelectVM()
        let vc = OptionSelectVC(viewModel: vm, type: type)
        
        vm.multiplyButtonDidTapped
            .subscribe(onNext: {
                self.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        vm.completeButtonDidTapped
            .subscribe(onNext: { texts in
                self.navigationController.popViewController(animated: true)
                if type == .activeArea {
                    parentVM.activeAreaTagSelected.accept(texts)
                } else {
                    parentVM.provisionTagSelected.accept(texts)
                }
            })
            .disposed(by: disposeBag)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}
