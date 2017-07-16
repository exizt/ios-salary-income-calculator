//
//  SalaryCalculatorOption.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 23..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation
class SalaryCalculatorOptions {
    var money : Double = 0
    var family : Int = 1
    var child : Int = 0
    var taxFree : Double = 100000
    var isAnnualIncome : Bool = true
    var isIncludedSeverance : Bool = false
    
    // 값 초기화
    func reset(){
        money = 0
        family = 1
        child = 0
        taxFree = 10000
        isAnnualIncome = true
        isIncludedSeverance = false
    }
    
    func equals(_ opt: SalaryCalculatorOptions) -> Bool
    {
        return opt.money == money
            && opt.taxFree == taxFree
            && opt.family == family
            && opt.child == child
            && opt.isAnnualIncome == isAnnualIncome
            && opt.isIncludedSeverance == isIncludedSeverance
    }
    
    func toString() -> String
    {
        return " Money : \(money) \n taxFree : \(taxFree) \n family : \(family) \n child : \(child) \n isAnnualIncome : \(isAnnualIncome) \n isIncludedSeverance : \(isIncludedSeverance) \n"
     }
}
