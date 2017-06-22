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
    
    func setOptions()
    {
        
    }
    
    func calculate(){
        var baseSalary = 0
        
        
    }
    
    func calculateNationalPension(_ adjustedSalary: Double)-> Double{
        var salary: Double = adjustedSalary
        if(adjustedSalary < 250000)
        {
            salary = 250000
        }
        if(adjustedSalary > 3980000)
        {
            salary = 3980000
        }
        
        
        var result : Double = salary * 0.01 * 0.34
        return result
        
    }
}
