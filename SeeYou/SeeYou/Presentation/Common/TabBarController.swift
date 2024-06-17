//
//  TabBarVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - UI properties
        
    // MARK: - Properties
    var previousSelectedIndex: Int?
    
    let horizontallyFadeAnimator = HorizontallyFadeAnimator()
    weak var fromDelegate: HorizontallyFadeAnimatorDelegate?
    weak var toDelegate: HorizontallyFadeAnimatorDelegate?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // MARK: - Helpers
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(
            _ tabBarController: UITabBarController,
            shouldSelect viewController: UIViewController
        ) -> Bool {
            self.previousSelectedIndex = tabBarController.selectedIndex
            return true
        }
        
        func tabBarController(
            _ tabBarController: UITabBarController,
            animationControllerForTransitionFrom fromVC: UIViewController,
            to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
            guard let previousSelectedIndex = self.previousSelectedIndex else { return nil }
            
            let toNav = toVC as? UINavigationController
            
            var toIndex: Int?
            
            for vc in toNav?.viewControllers ?? [] {
                if vc is ViewController {
                    toIndex = 0
                } else if vc is SecondVC {
                    toIndex = 1
                } else if vc is ThirdVC {
                    toIndex = 2
                } else if vc is MyInfoVC {
                    toIndex = 3
                }
            }
            
            self.fromDelegate = fromVC as? HorizontallyFadeAnimatorDelegate
            self.toDelegate = toVC as? HorizontallyFadeAnimatorDelegate
            
            // left to right
            if previousSelectedIndex < toIndex ?? previousSelectedIndex {
                self.horizontallyFadeAnimator.fadeHorizontallyDirection = .leftToRight
                
                return horizontallyFadeAnimator
            } else if previousSelectedIndex > toIndex ?? previousSelectedIndex {
                self.horizontallyFadeAnimator.fadeHorizontallyDirection = .rightToLeft
                
                return horizontallyFadeAnimator
            } else {
                return nil
            }
        }
}
