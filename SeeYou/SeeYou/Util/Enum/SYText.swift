//
//  SYText.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/09.
//

import Foundation

enum SYText {
    // MARK: - 탭 바
    static let home = "홈"
    static let search = "탐색"
    static let message_box = "쪽지함"
    
    // MARK: - 로그인 화면
    static let email = "邮箱"
    static let email_use_placeholder = "请输入您的邮箱地址"
    static let email_validate_error = "* 请再次确认一下邮箱地址。"
    
    static let password = "密码"
    static let password_placeholder = "请输入8位数以上的密码"
    static let password_validate_error = "최소 8자를 입력해주세요."
    
    static let login = "登录"
    static let signup = "注册会员"
    static let password_reset = "重置密码"
    
    // MARK: - 회원가입 화면
    
    /// 한국 여행은\n喜友와 함께하세요!
    static let signup_title = "韩国旅游\n喜友与您相伴而行"
    
    /// 한국을 안내해줄 地陪가\n여러분들을 기다리고 있어요!
    static let signup_description = "众多韩国通地陪们待与您相遇"
    
    /// 고객으로 시작
    static let signup_customer_title = "以顾客的身份登录"
    
    /// 地陪와 함께 편하게 여행을 즐겨보세요
    static let signup_customer_description = "和您的专属地陪享受韩国之行"
    
    /// 地陪로 시작
    static let signup_guide_title = "以地陪身份登录"
    
    /// 고객과 여행하면서 수익을 얻어보세요
    static let signup_guide_description = "和顾客一起边旅行边赚钱"
    
    /// 약관동의
    static let terms_of_use = "同意"
    
    /// [필수] 만 14세 이상입니다
    static let terms_of_age = "[必] 年满14周岁以上"
    
    /// [필수] 서비스 이용약관 동의
    static let terms_of_service = "[必] 同意服务使用条款"
    
    /// [필수] 개인정보 수집 및 이용 동의
    static let terms_of_information = "[必] 同意收集并使用个人信息"
    
    /// [선택] 마케팅 수신 정보 동의
    static let terms_of_marketing = "[选] 同意发送订阅信息"
    
    /// 동의하고 계속하기
    static let agree_and_continue = "同意并继续"
    
    // MARK: - 이메일 인증 화면
    
    /// 본인 확인을 위해\n이메일을 인증해주세요
    static let email_confirm_title = "请认证邮箱地址\n确认个人信息"
    /// 사용하실 이메일을 입력해주세요
    static let email_signup_placeholder = "请输入您的邮箱地址"
    
    /// 임시코드 보내기
    static let temporary_code_send = "发送验证码"
    
    /// 인증번호를 입력해주세요
    static let email_confirm_number_placeholder = "请输入验证码"
}
