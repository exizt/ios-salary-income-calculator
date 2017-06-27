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
    var child : Int = 1
    var taxFree : Double = 0
    var isAnnualIncome : Bool = true
    var isIncludedSeverance : Bool = false
    
    func equals(_ opt: SalaryCalculatorOptions) -> Bool
    {
        return opt.money == money
            && opt.family == family
            && opt.child == child
            && opt.taxFree == taxFree
            && opt.isAnnualIncome == isAnnualIncome
            && opt.isIncludedSeverance == isIncludedSeverance
    }
}
