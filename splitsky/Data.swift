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
        Currency(name: "British Pound", tla: "GBP", formatter: { v in "£\(v)" }),
        Currency(name: "Euro", tla: "EUR", formatter: { v in "\(v)€" }),
        Currency(name: "Danish Krone", tla: "DKK", formatter: { v in "\(v)kr" }),
        Currency(name: "Swedish Krona", tla: "SEK", formatter: { v in "\(v)kr" }),
        Currency(name: "Swiss Franc", tla: "CHF", formatter: { v in "\(v) CHF" }),
        Currency(name: "US Dollar", tla: "USD", formatter: { v in "$\(v)" }),
        Currency(name: "Turkish Lira", tla: "TRY", formatter: { v in "\(v)₺" })
    ]
    fileprivate static var _payments = [String:[Payment]]()
    fileprivate static var _listName: String = ""
    fileprivate static var _rates = Preferences.getRates() ?? [String: Any]()
    fileprivate static var _activeCurrency: String = Preferences.getLastCurrency() ?? "GBP"
    
    static func currencies() -> [Currency] {
        return _currencies
    }
    
    static func getCurrency(tla: String) -> Currency {
        return _currencies.filter { $0.tla() == tla }.first!
    }
    
    static func activeCurrency() -> Currency {
        return getCurrency(tla: _activeCurrency)
    }
    
    static func activeRate() -> Float {
        return getRate(currencyTla: _activeCurrency)
    }
    
    static func setActiveCurrency(currency: Currency) {
        _activeCurrency = currency.tla()
        Preferences.setLastCurrency(currency.tla())
    }
    
    static func currencyCount() -> Int {
        return _currencies.count
    }
    
    static func setRates(rates: [String: Any]) {
        _rates = rates
    }
    
    static func getRate(currencyTla: String) -> Float {
        return currencyTla == "GBP" ? 1.0 : _rates[currencyTla] as! Float
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
        Preferences.setLastFriend(name)
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
        Preferences.setLastFriend(newName)
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
        return Preferences.getLastFriend() ?? (_payments.count > 0 ? _payments.keys.sorted()[0] : "my friend")
    }
    
    static func theyOweMeGbp() -> Float {
        return _payments[listName()]!.reduce(0, { $0 + $1.theyOweMeGbp() } )
    }
    
    static func owingsSummary() -> String {
        let theyOweMeGbp = self.theyOweMeGbp()
        if abs(theyOweMeGbp) < 0.01 {
            return "owes me nothing"
        } else {
            let gbpText = "\(Data.getCurrency(tla: "GBP").format(amount: abs(theyOweMeGbp)))"
            let activeCurrencyText = Data.activeCurrency().tla() == "GBP" ? "" : "(\(Data.activeCurrency().format(amount: abs(theyOweMeGbp) * Data.activeRate())))"
            return (theyOweMeGbp > 0 ? "owes me " : "is owed ") + "\(gbpText) \(activeCurrencyText)"
        }
    }
    
}
