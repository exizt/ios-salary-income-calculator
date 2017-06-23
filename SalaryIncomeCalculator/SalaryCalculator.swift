//
//  SalaryCalculator.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation

class SalaryCalculator {
    var insurance = Insurance()
    var incomeTax = IncomeTax()
    var options = SalaryCalculatorOptions()
    var money : Double = 0
    var netSalary : Double = 0
    
    func setOptions()
    {
        
    }
    
    func prepare(_ income : Double)
    {
        money = income
    }
    func calculate(){
        let baseSalary : Double = computeSalary()
        
        insurance.calculate(baseSalary)
        incomeTax.calculate(baseSalary, family: 1, child: 0)
        
        netSalary = baseSalary - insurance.summary - incomeTax.summary + options.taxFree;
        
    }
    func getInsurance() -> Insurance{
        return insurance
    }
    func getIncomeTax() -> IncomeTax{
        return incomeTax
    }
    func Options() -> SalaryCalculatorOptions{
        return options
    }
    func computeSalary() -> Double
    {
        // 월 수령액 을 계산. 연봉 입력시에는 12 로 나눈다.
        var grossSalary : Double = 0
        
        if(Options().isAnnualIncome){
            grossSalary = (Options().isIncludedSeverance) ? money / 13 : money / 12
        } else {
            grossSalary = money
        }
        
        return grossSalary - Options().taxFree
    }
}
