//
//  FourthVC.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/21.
//

import UIKit

class FourthVC: UIViewController, HorizontallyFadeAnimatorDelegate, LoginVCDelegate {
    func touchUpMultiplyButton() {
        self.tabBarController?.selectedIndex = 0
        self.dismiss(animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let loginVC = LoginVC()
        loginVC.delegate = self
        let vc = UINavigationController(rootViewController: loginVC)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
}
