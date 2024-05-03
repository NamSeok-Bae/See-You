//
//  TabBarVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

class TabBarVC: UITabBarController {
    // MARK: - UI properties
        
    // MARK: - Properties
    var previousSelectedIndex: Int?
    
    let horizontallyFadeAnimator = HorizontallyFadeAnimator()
    weak var fromDelegate: HorizontallyFadeAnimatorDelegate?
    weak var toDelegate: HorizontallyFadeAnimatorDelegate?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.delegate = self
    }
    
    // MARK: - Helpers

    private func setupViews() {
        let tabOne = UINavigationController(rootViewController: ViewController())
        let tabOneBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = UINavigationController(rootViewController: SecondVC())
        let tabTwoBarItem = UITabBarItem(title: "탐색", image: UIImage(systemName: "house"), tag: 1)
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = UINavigationController(rootViewController: ThirdVC())
        let tabThreeBarItem = UITabBarItem(title: "쪽지함", image: UIImage(systemName: "house"), tag: 2)
        tabThree.tabBarItem = tabThreeBarItem
        
        let tabFour = UINavigationController(rootViewController: LoginVC())
        let tabFourBarItem = UITabBarItem(title: "로그인", image: UIImage(systemName: "house"), tag: 3)
        tabFour.tabBarItem = tabFourBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
    }
}

extension TabBarVC: UITabBarControllerDelegate {
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
                } else if vc is LoginVC {
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
