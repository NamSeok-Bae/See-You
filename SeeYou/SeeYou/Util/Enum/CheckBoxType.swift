//
//  CheckBoxType.swift
//  SeeYou
//
//  Created by 배남석 on 6/8/24.
//

import Foundation

enum CheckBoxType: String {
    case square
    case circle
    
    var defaultImageName: String {
        switch self {
        case .square:
            return "square"
        case .circle:
            return "circle"
        }
    }
    
    var checkImageName: String {
        switch self {
        case .square:
            return "checkmark.square.fill"
        case .circle:
            return "checkmark.circle.fill"
        }
    }
}
