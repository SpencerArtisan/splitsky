//
//  Util.swift
//  Splitsky
//
//  Created by Spencer Ward on 04/09/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation
import UIKit

class Util {
    static let DARK_GRAY = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    static let DARK_BLUE = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    static let ORANGE = UIColor(red: 1, green: 132/255, blue: 3/255, alpha: 1)
    
    static func toMoney(amount: Float) -> String  {
        let PenceDontMatter: Float = 1000
        let decPlc = abs(amount) >= PenceDontMatter || amount.truncatingRemainder(dividingBy: 1) < 0.01 ? 0 : 2
        return toMoney(amount: amount, decPlc: decPlc)
    }
    
    static func toMoney(amount: Float, decPlc: Int) -> String  {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = decPlc
        numberFormatter.maximumFractionDigits = decPlc
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    static func disable(_ button: UIButton) {
        button.backgroundColor = DARK_GRAY
        button.setTitleColor(UIColor.lightGray, for: UIControl.State())
    }
    
    static func enable(_ button: UIButton) {
        button.backgroundColor = DARK_BLUE
        button.setTitleColor(UIColor.white, for: UIControl.State())
    }
    
    static func orange(_ button: UIButton) {
        button.backgroundColor = ORANGE
    }
    
    static func setText(_ button: UIButton, text: String?) {
        if text != nil {
            button.setTitle(text, for: UIControl.State())
            button.setImage(nil, for: UIControl.State())
        }
    }
    
    static func setImage(_ button: UIButton, image: UIImage) {
        button.setTitle("", for: UIControl.State())
        button.setImage(image, for: UIControl.State())
    }
    
    static func center(_ button: UIButton) {
        button.titleLabel?.textAlignment = NSTextAlignment.center
    }

    static func right(_ button: UIButton) {
        button.titleLabel?.textAlignment = NSTextAlignment.right
    }
}
