//
//  AppCoordinator.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import UIKit
import RxSwift

protocol AppCoordinator: Coordinator {
    func start()
}

final class DefaultAppCoordinator: AppCoordinator {
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var childCoordinators: [Coordinator] = []
    weak var delegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
    }
    
    func start() {
        showTabBarViewController()
    }
    
    func showTabBarViewController() {
        let itemTypes: [TabBarItemType] = TabBarItemType.allCases
        let tabBarItems: [UITabBarItem] = itemTypes.map { createTabBarItem(type: $0) }
        let controllers: [UINavigationController] = tabBarItems.map { createNavigationController(item: $0) }
        let _  = controllers.map { startTabBarCoordinator(tabNavigationController: $0) }
        
        tabBarController.setViewControllers(controllers, animated: false)
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(tabBarController, animated: false)
    }
    
    private func createTabBarItem(type: TabBarItemType) -> UITabBarItem {
        return UITabBarItem(
            title: type.toName(),
            image: UIImage(systemName: type.toImageName()),
            tag: type.toInt())
    }
    
    private func createNavigationController(item: UITabBarItem) -> UINavigationController {
        let vc = UINavigationController()
        vc.tabBarItem = item
        vc.setNavigationBarHidden(false, animated: false)
        
        return vc
    }
    
    private func startTabBarCoordinator(tabNavigationController: UINavigationController) {
        let tag = tabNavigationController.tabBarItem.tag
        guard let item = TabBarItemType(index: tag) else { return }
        
        switch item {
        case .home:
            let coordinator = DefaultHomeCoordinator(navigationController: tabNavigationController)
            coordinator.delegate = self
            self.childCoordinators.append(coordinator)
            coordinator.start()
        case .matching:
            let coordinator = DefaultMatchingCoordinator(navigationController: tabNavigationController)
            coordinator.delegate = self
            self.childCoordinators.append(coordinator)
            coordinator.start()
        case .messgae:
            let coordinator = DefaultMessageCoordinator(navigationController: tabNavigationController)
            coordinator.delegate = self
            self.childCoordinators.append(coordinator)
            coordinator.start()
        case .myInfo:
            let coordinator = DefaultMyInfoCoordinator(navigationController: tabNavigationController)
            coordinator.delegate = self
            self.childCoordinators.append(coordinator)
            coordinator.start()
        }
    }
}

extension DefaultAppCoordinator: CoordinatorDelegate {
    func didFinished(childCoordinator: Coordinator) {
        tabBarController.selectedIndex = 0
    }
}
