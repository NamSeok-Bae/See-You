//
//  DefaultMyInfoCoordinator.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import UIKit
import RxSwift

final class DefaultMyInfoCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [any Coordinator] = []
    weak var delegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMyInfoViewController()
    }
    
    private func showMyInfoViewController() {
        let useCase = DefaultMyInfoUseCase()
        let vm = MyInfoVM(useCase: useCase)
        let vc = MyInfoVC(viewModel: vm)
        navigationController.pushViewController(vc, animated: false)
    }
}
