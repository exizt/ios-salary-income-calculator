//
//  Insurance.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation
class Insurance{
    var rate = InsuranceRate()
    var nationalPension : Double = 0
    var healthCare : Double = 0
    var longTermCare : Double = 0
    var employmentCare : Double = 0
    var summary : Double {
        get {
            return nationalPension + healthCare + longTermCare + employmentCare
        }
    }
    let np_lower_limit = Double(300000)
    let np_upper_limit = Double(4680000)
    let hc_upper_pay_limit = Double(3182760)

    /**
    * 4대 보험 계산
    */
    func calculate(_ salary: Double)
    {
        calculateNationalPension(salary)
        calculateEmploymentCare(salary)
        calculateHealthCare(salary)
        calculateLongTermCare(salary)
        
    }
    
    /**
    * 국민연금 요금 계산
    */
    private func calculateNationalPension(_ _salary: Double) {
        var salary : Double = 0
        if(_salary < np_lower_limit){
            salary = np_lower_limit
        } else if (_salary > np_upper_limit){
            salary = np_upper_limit
        } else {
            salary = _salary
        }
    
        salary = roundDown(salary, toNearest: 1000)
        
        nationalPension = roundDown(salary * rate.nationalPension,toNearest:10)
    }
    
    /**
    * 건강보험 요금 계산
    */
    private func calculateHealthCare(_ salary : Double) {
        healthCare = roundDown(salary * rate.healthCare, toNearest: 10)
        
        if(healthCare > hc_upper_pay_limit){
            healthCare = hc_upper_pay_limit
        }
    }
    
    /**
    * 장기요양 보험 요금 계산
    * 건강보험 (healthCare) 가 먼저 계산되어져 있어야 한다.
    * 건강보험 금액에 맞춰서 계산을 하게 된다.
    */
    private func calculateLongTermCare(_ salary : Double) {
        if(healthCare <= 0){
            return
        }
        longTermCare = roundDown(healthCare * rate.longTermCare, toNearest: 10)
        
    }
    
    /**
    * 고용보험 요금 계산
    */
    private func calculateEmploymentCare(_ salary : Double) {
        employmentCare = roundDown(salary * rate.employmentCare, toNearest: 10)
    }
    
    func getRate()->InsuranceRate {
        return rate;
    }
    
    func reset(){
        nationalPension = 0
        healthCare = 0
        longTermCare = 0
        employmentCare = 0
    }
    
    /**
    * 원 단위 절삭
    * 10 원 단위 절삭 roundDown(value,toNearest: 10)
    * 1000 원 단위 절삭 roundDown(value,toNearest: 1000)
    */
    func roundDown(_ value: Double, toNearest: Double) -> Double {
        return floor(value / toNearest) * toNearest
    }
}
