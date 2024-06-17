//
//  CommonErrorLabel.swift
//  SeeYou
//
//  Created by 배남석 on 6/8/24.
//

import UIKit

class CommonErrorLabel: UILabel {
    // MARK: - UI properties
    
    // MARK: - Properties
    var errorText: String?
    var successText: String?
    var isSucceed: Bool = false {
        didSet {
            if isSucceed {
                if let _ = successText {
                    configureSuccess()
                } else {
                    isHidden = true
                }
            } else {
                configureError()
            }
        }
    }
    
    // MARK: - Lifecycles
    init(errorText: String, successText: String? = nil) {
        super.init(frame: .zero)
        configureUI()
        self.errorText = errorText
        self.successText = successText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureUI() {
        font = .systemFont(ofSize: 12)
        textAlignment = .left
        isHidden = true
        sizeToFit()
    }
    
    private func configureSuccess() {
        self.text = successText
        self.textColor = .Palette.blue500
        self.isHidden = false
    }
    
    private func configureError() {
        self.text = errorText
        self.textColor = .Palette.red500
        self.isHidden = false
    }
}

