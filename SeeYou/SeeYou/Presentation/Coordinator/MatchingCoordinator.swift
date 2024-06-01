//
//  MatchingCoordinator.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import UIKit
import RxSwift

final class DefaultMatchingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMatchingViewController()
    }
    
    private func showMatchingViewController() {
        navigationController.pushViewController(SecondVC(), animated: false)
    }
}
