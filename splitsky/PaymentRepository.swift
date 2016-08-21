//
//  PaymentRepository.swift
//  Splitsky
//
//  Created by Spencer Ward on 12/08/2016.
//  Copyright © 2016 Spencer Ward. All rights reserved.
//

import Foundation

class PaymentRepository {
    static func load() -> [Payment] {
        let props = properties()
        let paymentCodes: [String] = props.valueForKey("Payments") as! [String]
        return paymentCodes.map {decode($0)}
    }
    
    static func save(payments: [Payment]) {
        let encodedPayments = payments.map {payment in encode(payment)}
        let props: NSMutableDictionary = NSMutableDictionary()
        props.setValue(encodedPayments, forKey: "Payments")
        props.writeToFile(path(), atomically: true)
    }
    
    private static func encode(payment: Payment) -> String {
        return "\(payment._amount):\(payment._type.toCode()):\(payment._label)"
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