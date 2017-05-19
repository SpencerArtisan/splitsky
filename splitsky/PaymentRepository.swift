//
//  PaymentRepository.swift
//  Splitsky
//
//  Created by Spencer Ward on 12/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    func mapPairs<OutKey: Hashable, OutValue>(_ transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    func filterPairs(_ includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}

class PaymentRepository {
    static func load() -> [String:[Payment]] {
        let props = properties()
        var payments: [String: [String]]
        let allPayments = props.value(forKey: "AllPayments")
        if allPayments == nil {
            payments = [String:[String]]()
        } else {
            payments = allPayments as! [String: [String]]
        }
        
        return payments.mapPairs {(name, payments) in (name, decode(payments))}
    }
    
    static func save(_ payments: [String:[Payment]]) {
        let encodedPayments = payments.mapPairs { (name, payments) in (name, encode(payments)) }
        let props: NSMutableDictionary = NSMutableDictionary()
        props.setValue(encodedPayments, forKey: "AllPayments")
        props.write(toFile: path(), atomically: true)
    }
    
    fileprivate static func encode(_ payments: [Payment]) -> [String] {
        return payments.map { encode($0) }
    }
    
    fileprivate static func encode(_ payment: Payment) -> String {
        return "\(payment.amount()):\(payment.type().toCode()):\(payment.label()):\(payment.myAllocations()):\(payment.theirAllocations()):\(payment.currency()):\(payment.rate())"
    }
    
    fileprivate static func decode(_ payments: [String]) -> [Payment] {
        return payments.map {decode($0)}
    }
    
    fileprivate static func decode(_ code: String) -> Payment {
        let parts = code.components(separatedBy: ":")
        let amount = Float(parts[0])!
        let type = Type.fromCode(parts[1])
        let label = parts.count >= 3 ? parts[2] : ""
        let myLobsters = parts.count >= 4 ? Float(parts[3])! : 0
        let theirLobsters = parts.count >= 5 ? Float(parts[4])! : 0
        let currency = parts.count >= 6 ? parts[5] : "GBP"
        let rate = parts.count >= 7 ? Float(parts[6])! : 1.0
        return Payment(even: amount, my: myLobsters, theirs: theirLobsters, currency: currency, rate: rate, type: type, label: label)
    }
    
    fileprivate static func properties() -> NSDictionary {
            let propsPath = path()
            let fileManager = FileManager.default
            if (!(fileManager.fileExists(atPath: propsPath))) {
                let bundle : NSString = Bundle.main.path(forResource: "Payments", ofType: "plist")! as NSString
                do {
                    try fileManager.copyItem(atPath: bundle as String, toPath: propsPath)
                } catch {
                }
            }
            
        return NSDictionary(contentsOfFile: propsPath)?.mutableCopy() as! NSDictionary
    }
    
    fileprivate static func path() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return paths.appendingPathComponent("Payments")
    }
}
