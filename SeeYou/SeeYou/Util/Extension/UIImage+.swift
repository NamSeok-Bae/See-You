//
//  UIImage+.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

extension UIImage {
    static let logo = UIImage(named: "logo")
    static let logo_fill = UIImage(named: "logo_fill")
    static let multiply = UIImage(systemName: "multiply")
    static let plus = UIImage(systemName: "plus")
    static let signup_customer = UIImage(named: "signup_customer")
    static let signup_guide = UIImage(named: "signup_guide")
    static let right_arrow = UIImage(named: "right_arrow")
    static let Tip = UIImage(named: "Tip")
    static let go_forward = UIImage(systemName: "goforward")
    
    func resize(targetSize: CGSize, opaque: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, opaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
