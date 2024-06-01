//
//  TabBarItemType.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation

enum TabBarItemType: String, CaseIterable {
    case home
    case matching
    case messgae
    case myInfo
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .matching
        case 2:
            self = .messgae
        case 3:
            self = .myInfo
        default:
            return nil
        }
    }
    
    func toInt() -> Int {
        switch self {
        case .home:
            return 0
        case .matching:
            return 1
        case .messgae:
            return 2
        case .myInfo:
            return 3
        }
    }
    
    func toName() -> String {
        switch self {
        case .home:
            return SYText.home
        case .matching:
            return SYText.matching
        case .messgae:
            return SYText.message
        case .myInfo:
            return SYText.login
        }
    }
    
    func toImageName() -> String {
        switch self {
        case .home:
            return "house"
        case .matching:
            return "house"
        case .messgae:
            return "house"
        case .myInfo:
            return "house"
        }
    }
}
