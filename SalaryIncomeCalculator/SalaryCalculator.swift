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
    var success : Bool = false
    
    func setOptions(_ _options: SalaryCalculatorOptions)
    {
        options = _options
    }

    /**
    * 계산하기
    */
    func calculate(){
        success = false
        
        // 월 단위 급여 계산
        let baseSalary : Double = computeSalary()
        if(baseSalary < 0){
            self.reset()
            success = false
            return
        }
        
        insurance.calculate(baseSalary)
        incomeTax.calculate(baseSalary, family: options.family, child: options.child)
        
        netSalary = baseSalary - insurance.summary - incomeTax.summary + options.taxFree;
        
        success = true
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
    func setInsuranceRate(_ rates:InsuranceRate){
        self.insurance.rate = rates
    }
    func computeSalary() -> Double
    {
        let money = Options().money
        
        // 월 수령액 을 계산. 연봉 입력시에는 12 로 나눈다.
        var grossSalary : Double = 0
        
        if(Options().isAnnualIncome){
            grossSalary = (Options().isIncludedSeverance) ? money / 13 : money / 12
        } else {
            grossSalary = money
        }
        
        return grossSalary - Options().taxFree
    }
    
    func reset(){
        insurance.reset()
        incomeTax.reset()
        options.reset()
        success = false
    }
    
    func isSuccess() -> Bool {
        return success
    }
}
