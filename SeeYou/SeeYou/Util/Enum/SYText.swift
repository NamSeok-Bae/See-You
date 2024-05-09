//
//  SYText.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import Foundation

enum SYText {
    // MARK: - 로그인 화면
    static let email = "邮箱"
    static let email_placeholder = "请输入您的邮箱地址"
    static let email_validate_error = "* 请再次确认一下邮箱地址。"
    
    static let password = "密码"
    static let password_placeholder = "请输入8位数以上的密码"
    static let password_validate_error = "최소 8자를 입력해주세요."
    
    static let login = "登录"
    static let signup = "注册会员"
    static let password_reset = "重置密码"
    
    // MARK: - 회원가입 화면
    static let signup_title = "韩国旅游\n喜友与您相伴而行"
    static let signup_description = "众多韩国通地陪们待与您相遇"
    
    static let signup_customer_title = "以顾客的身份登录"
    static let signup_customer_description = "和您的专属地陪享受韩国之行"
    
    static let signup_guide_title = "以地陪身份登录"
    static let signup_guide_description = "和顾客一起边旅行边赚钱"
    
    static let terms_of_use = "同意"
    static let terms_of_age = "[必] 年满14周岁以上"
    static let terms_of_service = "[必] 同意服务使用条款"
    static let terms_of_information = "[必] 同意收集并使用个人信息"
    static let terms_of_marketing = "[选] 同意发送订阅信息"
    static let agree_and_continue = "同意并继续"
}
