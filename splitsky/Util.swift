//
//  Util.swift
//  Splitsky
//
//  Created by Spencer Ward on 04/09/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class Util {
    static func toMoney(amount: Float) -> String  {
        let PenceDontMatter: Float = 1000
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = abs(amount) >= PenceDontMatter ? 0 : 2
        return formatter.stringFromNumber(amount)! as String
    }
}