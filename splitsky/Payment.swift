//
//  Payment.swift
//  Splitsky
//
//  Created by Spencer Ward on 12/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class Payment {
    var _amount: Float
    var _type: Type
    var _label: String
    
    init(amount: Float, type: Type, label: String) {
        _amount = amount
        _type = type
        _label = label
    }
}

enum Type : String {
    case iPaid = "IP"
    case theyPaid = "TP"
    case iSettled = "IS"
    case theySettled = "TS"
    
    func toCode() -> String {
        return rawValue
    }
    
    static func fromCode(str: String) -> Type {
        switch str {
        case "IP":
            return .iPaid
        case "TP":
            return .theyPaid
        case "IS":
            return .iSettled
        case "TS":
            return .theySettled
        default:
            assertionFailure()
            return .iPaid
        }
    }
}