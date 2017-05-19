//
//  Data.swift
//  Splitsky
//
//  Created by Spencer Ward on 10/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class Data {
    fileprivate static var _currencies = [
        Currency(name: "Euro", tla: "EUR"),
        Currency(name: "Danish Krone", tla: "DKK"),
        Currency(name: "Swiss Franc", tla: "CHF"),
        Currency(name: "Dollar", tla: "USD"),
        Currency(name: "Swedish Krona", tla: "SEK"),
        Currency(name: "Turkish Lira", tla: "TRY")
    ]
    fileprivate static var _payments = [String:[Payment]]()
    fileprivate static var _listName: String = ""
    fileprivate static var _rates = [String: Any]()
    fileprivate static var _activeCurrency: String = "GBP"
    
    static func currencies() -> [Currency] {
        return _currencies
    }
    
    static func activeCurrency() -> String {
        return _activeCurrency
    }
    
    static func setActiveCurrency(currency: Currency) {
        _activeCurrency = currency.tla()
    }
    
    static func currencyCount() -> Int {
        return _currencies.count
    }
    
    static func setRates(rates: [String: Any]) {
        _rates = rates
    }
    
    static func getRate(currencyTla: String) -> Float {
        return _rates[currencyTla] as! Float
    }
    
    static func newList() {
        var candidateSuffix = 2
        while _payments.keys.contains("friend \(candidateSuffix)") {
            candidateSuffix = candidateSuffix + 1
        }
        _payments["friend \(candidateSuffix)"] = [Payment]()
        setList("friend \(candidateSuffix)")
    }
    
    static func set(_ payments: [String:[Payment]]) {
        _payments = payments
        setList(defaultName())
    }
    
    static func setList(_ name: String) {
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
    
    static func changeName(_ oldName: String, newName: String) {
        _payments[newName] = _payments[oldName]!
        _payments.removeValue(forKey: oldName)
        PaymentRepository.save(_payments)
    }
    
    static func addPayment(_ payment: Payment) {
        _payments[listName()]!.append(payment)
        PaymentRepository.save(_payments)
    }
    
    static func removePayment(_ index: Int) {
        _payments[listName()]!.remove(at: index)
        PaymentRepository.save(_payments)
    }
    
    static func removeList(_ name: String) {
            _payments.removeValue(forKey: name)
        PaymentRepository.save(_payments)

        if Data.listName() == name {
            Data.setList(defaultName())
        }
    }
    
    static func defaultName() -> String {
        return _payments.count > 0 ? _payments.keys.sorted()[0] : "my friend"
    }
    
    static func theyOweMe() -> Float {
        return _payments[listName()]!.reduce(0, { $0 + $1.theyOweMe() } )
    }
    
}
