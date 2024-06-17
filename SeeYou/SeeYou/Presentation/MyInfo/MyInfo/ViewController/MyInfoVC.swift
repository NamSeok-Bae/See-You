//
//  MyInfoViewController.swift
//  SeeYou
//
//  Created by 배남석 on 6/1/24.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class MyInfoVC: UIViewController, HorizontallyFadeAnimatorDelegate, LoginVCDelegate {
    func touchUpMultiplyButton() {
        self.tabBarController?.selectedIndex = 0
        self.dismiss(animated: false)
    }
    
    // MARK: - UI properties
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    private let viewModel: MyInfoVM
    
    // MARK: - Lifecycles
    init(viewModel: MyInfoVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Helpers
    private func bind() {
        let input = MyInfoVM.Input()
        
        let output = viewModel.transform(input: input)
    }
}
