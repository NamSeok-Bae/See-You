//
//  UIColor+.swift
//  SeeYou
//
//  Created by 배남석 on 2024/05/03.
//

import UIKit

extension UIColor {
    enum Palette {
        // MARK: - Primary
        /// Primary-700
        /// #C03A02
        static let primary700 = UIColor(hexString: "C03A02")
        
        /// Primary-500
        /// #F34902
        static let primary500 = UIColor(hexString: "F34902")
        
        /// Primary-100
        /// #FFF8F5
        static let primary100 = UIColor(hexString: "FFF8F5")
        
        // MARK: - Gray Color
        /// Gray-1000
        /// #222222
        static let gray1000 = UIColor(hexString: "222222")
        
        /// Gray-700
        /// #616161
        static let gray700 = UIColor(hexString: "616161")
        
        /// Gray-500
        /// #9E9E9E
        static let gray500 = UIColor(hexString: "9E9E9E")
        
        /// Gray-200
        /// #EEEEEE
        static let gray200 = UIColor(hexString: "EEEEEE")
        
        /// Gray-100
        /// #F5F5F5
        static let gray100 = UIColor(hexString: "F5F5F5")
        
        /// Gray-0
        /// #FFFFFF
        static let gray0 = UIColor(hexString: "FFFFFF")
        
        // MARK: - Semantic Color
        /// Red-500 (Warning)
        /// #EE1E1E
        static let red500 = UIColor(hexString: "EE1E1E")
        
        /// Red-100 (Warning)
        /// #FBF9F9
        static let red100 = UIColor(hexString: "FBF9F9")
        
        /// Blue-500 (Positive)
        /// #1462FC
        static let blue500 = UIColor(hexString: "1462FC")
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(hexString: String) {
        let arr = Array(hexString)
        var rgb: [Int] = []
        for index in stride(from: 0, to: 5, by: 2) {
            rgb.append(Int(String(arr[index...(index+1)]), radix: 16)!)
        }
        self.init(red: rgb[0], green: rgb[1], blue: rgb[2])
    }
}
