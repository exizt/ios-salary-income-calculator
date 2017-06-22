//
//  SalaryCalculator.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation

class SalaryCalculator {
    var money : Int?
    var family : Int?
    var child : Int?
    var taxFree : Int?
    var insurance = Insurance()
    var incomeTax = IncomeTax()
    
    func setOptions()
    {
        
    }
    
    func calculate(){
        var adjustedSalary : Double = 2000000
        
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
