//
//  CommonTitleLabel.swift
//  SeeYou
//
//  Created by 배남석 on 6/8/24.
//

import UIKit

class CommonTitleLabel: UILabel {
    // MARK: - UI properties
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        configureText(text: text)
    }
    
    convenience init(text: String, isEssentail: Bool) {
        self.init(frame: .zero)
        configureText(text: text)
        configureEssentail(isEssentail: isEssentail)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI() {
        self.sizeToFit()
        self.numberOfLines = 0
        self.textAlignment = .left
    }
    
    func configureEssentail(isEssentail: Bool) {
        if !isEssentail { return }
        guard let text = self.text else { return }
        let newText = text + "*"
        let attributedStr = NSMutableAttributedString(string: newText)
        attributedStr.addAttribute(
            .foregroundColor,
            value: UIColor.Palette.red500,
            range: (newText as NSString).range(of:"*"))
        self.attributedText = attributedStr
    }
    
    func configureText(text: String) {
        self.text = text
    }
}
