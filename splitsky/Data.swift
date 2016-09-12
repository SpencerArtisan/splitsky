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
        var candidateSuffix = 2
        while _payments.keys.contains("friend \(candidateSuffix)") {
            candidateSuffix = candidateSuffix + 1
        }
        _payments["friend \(candidateSuffix)"] = [Payment]()
        setList("friend \(candidateSuffix)")
    }
    
    static func set(payments: [String:[Payment]]) {
        _payments = payments
        setList(defaultName())
    }
    
    static func setList(name: String) {
        _listName = name
        if _payments[_listName] == nil {
            _payments[_listName] = [Payment]()
        }
    }
    
    static func listCount() -> Int {
        return _payments.count
    }
    
    static func listName() -> String {
        return _listName
    }
    
    static func isNamed() -> Bool {
        return _listName != "" && _listName != "my friend"
    }
    
    static func paymentCount() -> Int {
        return payments().count
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

        if Data.listName() == name {
            Data.setList(defaultName())
        }
    }
    
    static func defaultName() -> String {
        return _payments.count > 0 ? _payments.keys.sort()[0] : "my friend"
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