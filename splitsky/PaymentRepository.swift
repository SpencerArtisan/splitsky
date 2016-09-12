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
    
    func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    func filterPairs(@noescape includeElement: Element throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}

class PaymentRepository {
    static func load() -> [String:[Payment]] {
        let props = properties()
        var payments: [String: [String]]
        let allPayments = props.valueForKey("AllPayments")
        if allPayments == nil {
            payments = [String:[String]]()
        } else {
            payments = allPayments as! [String: [String]]
        }
        
        return payments.mapPairs {(name, payments) in (name, decode(payments))}
    }
    
    static func save(payments: [String:[Payment]]) {
        let encodedPayments = payments.mapPairs { (name, payments) in (name, encode(payments)) }
        let props: NSMutableDictionary = NSMutableDictionary()
        props.setValue(encodedPayments, forKey: "AllPayments")
        props.writeToFile(path(), atomically: true)
    }
    
    private static func encode(payments: [Payment]) -> [String] {
        return payments.map { encode($0) }
    }
    
    private static func encode(payment: Payment) -> String {
        return "\(payment._amount):\(payment._type.toCode()):\(payment._label)"
    }
    
    private static func decode(payments: [String]) -> [Payment] {
        return payments.map {decode($0)}
    }
    
    private static func decode(code: String) -> Payment {
        let parts = code.componentsSeparatedByString(":")
        let amount = Float(parts[0])!
        let type = Type.fromCode(parts[1])
        let label = parts.count >= 3 ? parts[2] : ""
        return Payment(amount: amount, type: type, label: label)
    }
    
    private static func properties() -> NSDictionary {
            let propsPath = path()
            let fileManager = NSFileManager.defaultManager()
            if (!(fileManager.fileExistsAtPath(propsPath))) {
                let bundle : NSString = NSBundle.mainBundle().pathForResource("Payments", ofType: "plist")!
                do {
                    try fileManager.copyItemAtPath(bundle as String, toPath: propsPath)
                } catch {
                }
            }
            
        return NSDictionary(contentsOfFile: propsPath)?.mutableCopy() as! NSDictionary
    }
    
    private static func path() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return paths.stringByAppendingPathComponent("Payments")
    }
}