//
//  ViewController.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

class ViewController: UIViewController, HorizontallyFadeAnimatorDelegate {
    // MARK: - UI properties
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    private func setupNavigationBar() {
        title = "홈"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}

