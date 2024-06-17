//
//  OptionType.swift
//  SeeYou
//
//  Created by 배남석 on 6/13/24.
//

import Foundation

enum OptionType {
    case activeArea
    case provision
    
    func toName() -> String {
        switch self {
        case .activeArea:
            return SYText.active_area
        case .provision:
            return SYText.provision_of_services
        }
    }
    
    func toPlaceholder() -> String {
        switch self {
        case .activeArea:
            return "지역을 입력해주세요."
        case .provision:
            return "서비스를 입력해주세요."
        }
    }
    
    func toLabelText() -> String {
        switch self {
        case .activeArea:
            return "많이 찾는 지역"
        case .provision:
            return "많이 찾는 서비스"
        }
    }
    
    func toSelecetedLabelText() -> String {
        switch self {
        case .activeArea:
            return "선택한 지역"
        case .provision:
            return "선택한 서비스"
        }
    }
    
    func toSelecetedPlaceholder() -> String {
        switch self {
        case .activeArea:
            return "선택한 지역이 없어요."
        case .provision:
            return "선택한 서비스이 없어요."
        }
    }
}
