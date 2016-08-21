//
//  Data.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class Data {
    private static var _payments = [Payment]()
    
    static func set(payments: [Payment]) {
        _payments = payments
    }
    
    static func paymentCount() -> Int {
        return _payments.count
    }
    
    static func payments() -> [Payment] {
        return _payments
    }
    
    static func addPayment(payment: Payment) {
        _payments.append(payment)
        PaymentRepository.save(_payments)
    }
    
    static func removePayment(index: Int) {
        _payments.removeAtIndex(index)
        PaymentRepository.save(_payments)
    }
    
    static func iPaidTotal() -> Float {
        return sum(Type.iPaid)
    }
    
    static func theyPaidTotal() -> Float {
        return sum(Type.theyPaid)
    }
    
    static func iSettledTotal() -> Float {
        return sum(Type.iSettled)
    }
    
    static func theySettledTotal() -> Float {
        return sum(Type.theySettled)
    }
    
    private static func sum(type: Type) -> Float {
        return _payments.filter({$0._type == type}).reduce(0, combine: { $0 + $1._amount } )
    }
    
    static func totalOwings() -> Float {
        return iSettledTotal() - theySettledTotal() + (iPaidTotal() - theyPaidTotal()) / 2
    }
}