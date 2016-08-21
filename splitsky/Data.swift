//
//  Data.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class Data {
    private static var _payments = [String:[Payment]]()
    private static var _listName: String = ""
    
    static func newList() {
        var candidateSuffix = 1
        while _payments.keys.contains("List \(candidateSuffix)") {
            candidateSuffix = candidateSuffix + 1
        }
        _payments["List \(candidateSuffix)"] = [Payment]()
        setList("List \(candidateSuffix)")
    }
    
    static func set(payments: [String:[Payment]]) {
        _payments = payments
        _listName = payments.first!.0
    }
    
    static func setList(name: String) {
        _listName = name
    }
    
    static func listCount() -> Int {
        return _payments.count
    }
    
    static func listName() -> String {
        return _listName
    }
    
    static func paymentCount() -> Int {
        return _payments[_listName]!.count
    }
    
    static func payments() -> [Payment] {
        return _payments[_listName]!
    }
    
    static func allPayments() -> [String: [Payment]] {
        return _payments
    }
    
    static func addPayment(payment: Payment) {
        _payments[_listName]!.append(payment)
        PaymentRepository.save(_payments)
    }
    
    static func removePayment(index: Int) {
        _payments[_listName]!.removeAtIndex(index)
        PaymentRepository.save(_payments)
    }
    
    static func removeList(name: String) {
            _payments.removeValueForKey(name)
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
        return _payments[_listName]!.filter({$0._type == type}).reduce(0, combine: { $0 + $1._amount } )
    }
    
    static func totalOwings() -> Float {
        return iSettledTotal() - theySettledTotal() + (iPaidTotal() - theyPaidTotal()) / 2
    }
}