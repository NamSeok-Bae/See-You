//
//  CommonTextField.swift
//  SeeYou
//
//  Created by 배남석 on 6/8/24.
//

import UIKit

class CommonTextField: UITextField {
    // MARK: - UI properties
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    init(placeholder: String) {
        super.init(frame: .zero)
        configureUI()
        configurePlaceholder(text: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI() {
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        layer.cornerRadius = CGFloat.toScaledHeight(value: 8)
        layer.borderColor = UIColor.Palette.gray200.cgColor
        layer.borderWidth = 1
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        leftView = view
        leftViewMode = .always
        rightView = view
        rightViewMode = .always
    }
    
    func configurePlaceholder(text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor : UIColor.Palette.gray500])
    }
}
