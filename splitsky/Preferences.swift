//
//  Preferences.swift
//  illbeback
//
//  Created by Spencer Ward on 21/12/2015.
//  Copyright © 2015 Spencer Ward. All rights reserved.
//

import Foundation

class Preferences {
    private static var props: NSDictionary?

    static func hadLobsterHelp() -> Bool {
        return (properties().value(forKey: "hadLobsterHelp") as? Bool) ?? false
    }
    
    static func hadLobsterHelp(value: Bool) {
        properties().setValue(value, forKey: "hadLobsterHelp")
        write()
    }

    static func setLastFriend(_ value: String) {
        properties().setValue(value, forKey: "lastFriend")
        write()
    }
    
    static func getLastFriend() -> String? {
        return properties().value(forKey: "lastFriend") as? String
    }
    
    static func setLastCurrency(_ value: String) {
        properties().setValue(value, forKey: "lastCurrency")
        write()
    }
    
    static func getLastCurrency() -> String? {
        return properties().value(forKey: "lastCurrency") as? String
    }
    
    static func setRates(_ rates: [String: Any]) {
        properties().setValue(rates, forKey: "rates")
        write()
    }
    
    static func getRates() -> [String: Any]? {
        return properties().value(forKey: "rates") as? [String: Any]
    }
    
    private static func properties() -> NSDictionary {
        if props == nil {
            let propsPath = path()
            let fileManager = FileManager.default
            if (!(fileManager.fileExists(atPath: propsPath))) {
                let bundle = Bundle.main.path(forResource: "Prefs", ofType: "plist")!
                do {
                    try fileManager.copyItem(atPath: bundle as String, toPath: propsPath)
                } catch {
                }
            }
            
            props = NSDictionary(contentsOfFile: propsPath)?.mutableCopy() as? NSDictionary
        }
        return props!
    }
    
    private static func path() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return paths.appendingPathComponent("Prefs.plist")
    }
    
    private static func write() {
        properties().write(toFile: path(), atomically: true)
    }
}
