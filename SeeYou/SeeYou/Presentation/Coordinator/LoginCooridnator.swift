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
    
    private func showLoginViewController() {
        let useCase = DefaultLoginUseCase()
        let vm = LoginVM(useCase: useCase)
        let vc = LoginVC(viewModel: vm)
        
        vm.multiplyButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                if let vc = self.navigationController.viewControllers.first {
                    self.navigationController.viewControllers = [vc]
                }
                self.navigationController.tabBarController?.selectedIndex = 0
            })
            .disposed(by: disposeBag)
        
        vm.signUpButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                let vc = SignUpVC()
                self.navigationController.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationController.viewControllers = [vc]
    }
}
