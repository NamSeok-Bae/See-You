//
//  LoginVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

class LoginVC: UIViewController, HorizontallyFadeAnimatorDelegate {
    // MARK: - UI properties
    private lazy var plusButton = UIBarButtonItem(
        image: UIImage(systemName: "multiply"),
        style: .plain,
        target: self,
        action: #selector(buttonDidTapped(_:))
    )
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        title = "로그인"
        navigationItem.rightBarButtonItem = plusButton
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    @objc private func buttonDidTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
}
