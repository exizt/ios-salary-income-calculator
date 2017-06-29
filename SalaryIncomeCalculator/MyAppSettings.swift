//
//  MyAppSettings.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 30..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation
struct MyAppSettings {
    enum Rates : String {
        case nationalPension
        case healthCare
        case longTermCare
        case employmentCare
        func get() -> String{
            return getKey()
        }
        func getKey() -> String {
            return prefix() + self.rawValue
        }
        func prefix()->String {
            return "settings-rate-"
        }
    }
    enum InputDefaults : String {
        case family
        case child
        case taxfree
        case includedSev
        func getKey() -> String {
            return prefix() + self.rawValue
        }
        func prefix()->String {
            return "settings-inputdefault-"
        }
    }
}
