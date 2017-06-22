//
//  SalaryCalculator.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation

class SalaryCalculator {
    var money : Double = 0
    var family : Int = 1
    var child : Int = 0
    var taxFree : Int?
    var insurance = Insurance()
    var incomeTax = IncomeTax()
    
    func setOptions()
    {
        
    }
    
    func prepare(_ income : Double)
    {
        money = income
    }
    func calculate(){
        var adjustedSalary : Double = money
        
        insurance.calculate(adjustedSalary)
        incomeTax.calculate(adjustedSalary, family: 1, child: 0, nationalPension: insurance.nationalPension)
        
        
    }
    func getInsurance() -> Insurance{
        return insurance
    }
    func getIncomeTax() -> IncomeTax{
        return incomeTax
    }
}
