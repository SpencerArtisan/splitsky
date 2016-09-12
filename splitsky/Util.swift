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
    
    static func toMoney(amount: Float) -> String  {
        let PenceDontMatter: Float = 1000
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = abs(amount) >= PenceDontMatter ? 0 : 2
        return formatter.stringFromNumber(amount)! as String
    }
    
    static func disable(button: UIButton) {
        button.backgroundColor = DARK_GRAY
        button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
    }
    
    static func enable(button: UIButton) {
        button.backgroundColor = DARK_BLUE
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    static func setText(button: UIButton, text: String) {
        button.setTitle(text, forState: UIControlState.Normal)
        button.setImage(nil, forState: UIControlState.Normal)
    }
    
    static func setImage(button: UIButton, image: UIImage) {
        button.setTitle("", forState: UIControlState.Normal)
        button.setImage(image, forState: UIControlState.Normal)
    }
    
    static func center(button: UIButton) {
        button.titleLabel?.textAlignment = NSTextAlignment.Center
    }
}