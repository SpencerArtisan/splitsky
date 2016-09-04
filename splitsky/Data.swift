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
        while _payments.keys.contains("tab \(candidateSuffix)") {
            candidateSuffix = candidateSuffix + 1
        }
        _payments["tab \(candidateSuffix)"] = [Payment]()
        setList("tab \(candidateSuffix)")
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
        if _payments[_listName] == nil {
            setList(_payments.keys.sort()[0])
        }
        return _listName
    }
    
    static func isNamed() -> Bool {
        return !_listName.containsString("tab") && _listName != ""
    }
    
    static func paymentCount() -> Int {
        return _payments[listName()]!.count
    }
    
    static func payments() -> [Payment] {
        return _payments[listName()]!
    }
    
    static func allPayments() -> [String: [Payment]] {
        return _payments
    }
    
    static func changeName(oldName: String, newName: String) {
        _payments[newName] = _payments[oldName]!
        _payments.removeValueForKey(oldName)
        PaymentRepository.save(_payments)
    }
    
    static func addPayment(payment: Payment) {
        _payments[listName()]!.append(payment)
        PaymentRepository.save(_payments)
    }
    
    static func removePayment(index: Int) {
        _payments[listName()]!.removeAtIndex(index)
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
    
    static func theyBorrowedTotal() -> Float {
        return sum(Type.theyBorrowed)
    }
    
    static func iBorrowedTotal() -> Float {
        return sum(Type.iBorrowed)
    }
    
    private static func sum(type: Type) -> Float {
        return _payments[listName()]!.filter({$0._type == type}).reduce(0, combine: { $0 + $1._amount } )
    }
    
    static func totalOwings() -> Float {
        return theyBorrowedTotal() - iBorrowedTotal() + (iPaidTotal() - theyPaidTotal()) / 2
    }
    
}