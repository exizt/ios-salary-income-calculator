//
//  MyAppSettings.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 30..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation

protocol UserAppSettingInterface {
    var rawValue: String { get }
    func getKey()->String
    func prefix()->String
    func getValue()->String
    func set(_ _value: Any?)
    func key()->String
    func value()->String
}

extension UserAppSettingInterface {
}
struct MyAppSettings {
    enum Item : String {
        case family
        case child
        case taxfree
        case includedsev
        case rate_np
        case rate_hc
        case rate_ltc
        case rate_ec
    }
    enum Rates : String,UserAppSettingInterface {
        case nationalPension
        case healthCare
        case longTermCare
        case employmentCare
        func getKey() -> String {
            return prefix() + self.rawValue
        }
        func prefix()->String {
            return "SHNUserSetting.Rate-"
        }
        func getValue()->String {
            return UserDefaults.standard.string(forKey: getKey())!
        }
        func set(_ _value: Any?){
            if var value = _value as? Double{
                if (value > 100.0) {
                    value = 100.0
                } else if (value < 0.0) {
                    value = 0.0
                }
                UserDefaults.standard.set(value,forKey: getKey())
            }
        }
        // aliases
        func key()->String{
            return getKey()
        }
        func value()->String{
            return getValue()
        }
    }
    enum InputDefaults : String,UserAppSettingInterface {
        case family
        case child
        case taxfree
        case includedSev
        case temp
        func getKey() -> String {
            return prefix() + self.rawValue
        }
        func prefix()->String {
            return "SHNUserSetting.InputDefault-"
        }
        func getValue()->String {
            return UserDefaults.standard.string(forKey: getKey())!
        }
        func set(_ _value: Any?){
            switch self {
            case .family:
                if var value = _value as? Int{
                    if( value > 20){
                        value = 20
                    } else if(value<1){
                        value = 1
                    }
                    UserDefaults.standard.set(value,forKey: getKey())
                }
                break
            case .child:
                if var value = _value as? Int{
                    if( value > 20){
                        value = 20
                    } else if(value<0){
                        value = 0
                    }
                    UserDefaults.standard.set(value,forKey: getKey())
                }
                break
            case .taxfree:
                if var value = _value as? Int{
                    if( value > 100000){
                        value = 100000
                    } else if(value<0){
                        value = 0
                    }
                    UserDefaults.standard.set(value,forKey: getKey())
                }
                break
            case .includedSev:
                if let value = _value as? Bool{
                    UserDefaults.standard.set(value,forKey: getKey())
                }
                break
            default:
                UserDefaults.standard.set(_value,forKey: getKey())
                break
            }
        }
        // aliases
        func key()->String{
            return getKey()
        }
        func value()->String{
            return getValue()
        }
    }
}
