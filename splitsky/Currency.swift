//
//  Currency.swift
//  Splitsky
//
//  Created by Spencer Ward on 19/05/2017.
//  Copyright © 2017 Spencer Ward. All rights reserved.
//

import Foundation

class Currency {
    fileprivate var _name: String
    fileprivate var _tla: String
    fileprivate var _formatter: (String) -> String
    
    init(name: String, tla: String, formatter: @escaping (String) -> String) {
        _name = name
        _tla = tla
        _formatter = formatter
    }
    
    func format(amount: Float) -> String {
        return _formatter(Util.toMoney(amount: amount))
    }

    func setName(_ name: String) {
        _name = name
    }
    
    func name() -> String {
        return _name
    }
    
    func setTla(_ tla: String) {
        _tla = tla
    }
    
    func tla() -> String {
        return _tla
    }
}
