//
//  SecondVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

class SecondVC: UIViewController, HorizontallyFadeAnimatorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "탐색"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}
