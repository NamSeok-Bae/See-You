//
//  ToastType.swift
//  SeeYou
//
//  Created by 배남석 on 6/13/24.
//

import Foundation

enum ToastType {
    case alreadySelect
    
    func toText() -> String {
        switch self {
        case .alreadySelect:
            return "이미 선택하셨습니다."
        }
    }
}
