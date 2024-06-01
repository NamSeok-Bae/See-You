//
//  Responsable.swift
//  SeeYou
//
//  Created by 배남석 on 5/30/24.
//

import Foundation

protocol Responsable {
    associatedtype ResponseDTO: Decodable
}

enum ResponseType {
    case emailSend
    case emailResend
    case emailValify
    case checkNickname
    case signUpTourist
    case signUpDipei
    case login
    
    var path: String {
        switch self {
        case .emailSend:
            return "auth/send-code"
        case .emailResend:
            return "auth/resend-code"
        case .emailValify:
            return "auth/verify-code"
        case .checkNickname:
            return "auth/check-nickname"
        case .signUpTourist:
            return "auth/tourist"
        case .signUpDipei:
            return "auth/dipei"
        case .login:
            return "auth/login"
        }
    }
}
