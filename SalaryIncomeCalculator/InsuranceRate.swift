//
//  InsuranceRate.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation
struct InsuranceRate {
    var _nationalPension : Double = 4.5
    var nationalPension : Double {
        get {
            return _nationalPension * 0.01
        }
        set(newVal){
            if(newVal <= 0){
                _nationalPension = 0
            } else if(newVal > 100) {
                _nationalPension = 100
            } else {
                _nationalPension = newVal
            }
        }
    }
    var _healthCare : Double = 3.06
    var healthCare : Double {
        get {
            return _healthCare * 0.01
        }
        set(newVal){
            if(newVal <= 0){
                _healthCare = 0
            } else if(newVal > 100) {
                _healthCare = 100
            } else {
                _healthCare = newVal
            }
        }
    }
    var _longTermCare : Double = 6.55
    var longTermCare : Double {
        get {
            return _longTermCare * 0.01
        }
        set(newVal){
            if(newVal <= 0){
                _longTermCare = 0
            } else if(newVal > 100) {
                _longTermCare = 100
            } else {
                _longTermCare = newVal
            }
        }
    }
    var _employmentCare : Double = 0.65
    var employmentCare : Double {
        get {
            return _employmentCare * 0.01
        }
        set(newVal){
            if(newVal <= 0){
                _employmentCare = 0
            } else if(newVal > 100) {
                _employmentCare = 100
            } else {
                _employmentCare = newVal
            }
        }
    }
    mutating func initValues(){
        self._nationalPension = 4.5
        self._healthCare = 3.06
        self._longTermCare = 6.55
        self._employmentCare = 0.65
    }
    
}
