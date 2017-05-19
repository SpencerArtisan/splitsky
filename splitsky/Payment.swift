//
//  Payment.swift
//  Splitsky
//
//  Created by Spencer Ward on 12/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class Payment {
    fileprivate var _amount: Float
    fileprivate var _myLobsters: Float
    fileprivate var _theirLobsters: Float
    fileprivate var _type: Type
    fileprivate var _label: String
    fileprivate var _currency: String
    fileprivate var _rate: Float
    
    convenience init(amount: Float, currency: String, rate: Float, type: Type, label: String) {
        self.init(even:amount, my:0, theirs: 0, currency: currency, rate: rate, type: type, label: label)
    }
    
    init(even: Float, my: Float, theirs: Float, currency: String, rate: Float, type: Type, label: String) {
        _amount = even
        _myLobsters = my
        _theirLobsters = theirs
        _type = type
        _label = label
        _currency = currency
        _rate = rate
    }
    
    func amount() -> Float {
        return _amount
    }
    
    func setLabel(_ text: String) {
        _label = text
    }
    
    func hasLabel() -> Bool {
        return _label != ""
    }
    
    func label() -> String {
        return _label
    }
    
    func type() -> Type {
        return _type
    }
    
    func theyOweMe() -> Float {
        if _type == Type.iBorrowed {
            return -_amount
        } else if _type == Type.theyBorrowed {
            return _amount
        } else if _type == Type.iPaid {
            return evenlySplit()/2 + _theirLobsters
        } else {
            return -evenlySplit()/2 - _myLobsters
        }
    }
    
    func allocateToMe(_ amount: Float) {
        _myLobsters = _myLobsters + amount
    }

    func allocateToThem(_ amount: Float) {
        _theirLobsters = _theirLobsters + amount
    }
    
    func evenlySplit() -> Float {
        return _amount - _myLobsters - _theirLobsters
    }
    
    func isUneven() -> Bool {
        return _myLobsters > 0 || _theirLobsters > 0
    }
    
    func myAllocations() -> Float {
        return _myLobsters
    }
    
    func theirAllocations() -> Float {
        return _theirLobsters
    }
}

enum Type : String {
    case iPaid = "IP"
    case theyPaid = "TP"
    case iBorrowed = "TS"
    case theyBorrowed = "IS"

    func toCode() -> String {
        return rawValue
    }
    
    static func fromCode(_ str: String) -> Type {
        switch str {
        case "IP":
            return .iPaid
        case "TP":
            return .theyPaid
        case "IS":
            return .theyBorrowed
        case "TS":
            return .iBorrowed
        default:
            assertionFailure()
            return .iPaid
        }
    }
}
