//
//  Coordinator.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import UIKit
import RxSwift

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? {get set}
    var disposeBag: DisposeBag {get set}
    
    init(navigationController: UINavigationController)
}

protocol CoordinatorDelegate: AnyObject {
    func didFinished(childCoordinator: Coordinator)
}
