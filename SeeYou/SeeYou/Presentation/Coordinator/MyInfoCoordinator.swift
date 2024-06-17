//
//  MyInfoCoordinator.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import UIKit
import RxSwift

final class DefaultMyInfoCoordinator: Coordinator{
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let _ = UserDefaults.standard.string(forKey: "id") {
            showMyInfoViewController()
        } else {
            startLogiCoordinator()
        }
    }
    
    private func startLogiCoordinator() {
        let coordinator = DefaultLoginCooridnator(navigationController: navigationController)
        coordinator.delegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func showMyInfoViewController() {
        let useCase = DefaultMyInfoUseCase()
        let vm = MyInfoVM(useCase: useCase)
        let vc = MyInfoVC(viewModel: vm)
        
        navigationController.pushViewController(vc, animated: false)
    }
}

extension DefaultMyInfoCoordinator: CoordinatorDelegate {
    func didFinished(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== childCoordinator })
        if let vc = navigationController.viewControllers.first {
            navigationController.viewControllers = [vc]
        }
        delegate?.didFinished(childCoordinator: self)
    }
}
