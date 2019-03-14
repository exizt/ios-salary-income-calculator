//
//  IncomeTax.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation
class IncomeTax{
    let isDebugMode : Bool = false
    var incomeTax : Double = 0
    var localTax : Double {
        get {
            return roundDown(incomeTax * 0.1, toNearest: 10)
        }
    }
    var summary : Double {
        get {
            return incomeTax + localTax
        }
    }

    
    func calculate(_ salary: Double, family: Int, child: Int)
    {
        if(salary < 106 * 10000){
            incomeTax = 0
            return
        }
        if(salary > 1000 * 10000){
            incomeTax = getHighAmountTax(salary) + calculateIncomeTax(1000 * 10000, family: family, child: child)
        } else {
            
            incomeTax = calculateIncomeTax(salary, family: family, child: child)
        }
        
        if(incomeTax < 0){
           incomeTax = 0
        }
    }
    /**
    * salary : 월봉
    *
    */
    func calculateIncomeTax(_ salary: Double, family: Int, child: Int) -> Double
    {
        var income : Double = salary
        
        //최대값
        if(income > 1000 * 10000)
        {
            income = 1000 * 10000
        }
        // 1. 구간별 액수 조정 (소득 구간 의 중간값으로 계산한다.)
        let adjustedSalary : Double = getAdjustedSalary(income)
 
        // 2. 연간 근로소득금액 산출 : 공제의 기준이 되는 연간 소득 금액을 말한다. (복잡하게 들어가면 기타 등등의 소득까지 다 합쳐진다)
        let adjustedSalaryYearly : Double = adjustedSalary * 12
        
        // 3. 기초 소득공제 산출 (=연간 근로 소득 공제)
        let basicDeduction : Double = getBasicDeduction(adjustedSalaryYearly)
        
        // 4. 종합 소득공제 산출 (인적공제, 연금보험공제, 특별소득공제 등)
        let familyDeduction : Double = getFamilyDeduction(family:family, child:child)
        let pensionDeduction : Double = getPensionDeduction(adjustedSalary)
        let deductionOthers : Double = getDeductionOthers(adjustedSalaryYearly, family:family, child:child)
        
        // 5. 과세표준 산출
        let taxbasedSalary : Double = adjustedSalaryYearly - basicDeduction - familyDeduction - pensionDeduction - deductionOthers
        
        // 6. 산출세액 산출 (구간에 맞춰서 세율을 통한 계산)
        let taxYearly : Double = getIncomeTax(taxbasedSalary)
        
        // 7. 결정세액 산출. (= 세액 - 근로 소득 세액 공제)
        let creditTax : Double = getCreditTax(adjustedSalaryYearly, taxYearly: taxYearly)
        let taxYearlyFix : Double = taxYearly - creditTax
        
        /**
         * 8. 간이세액 산출
         * 설명 : 왜 간이세액 이냐면, 한달은 정확히 30일이 아니기 때문이다. 상세하게 하려면 일자 를 계산해서 정산한다.
         * 월간 간이세액 = 연간 결정세액 / 12
         * 절삭정책 : 원 단위 이하 절사
         */
        let tax : Double = roundDown( taxYearlyFix/12, toNearest: 10)
        
        if(isDebugMode){
            print("-------- 소득세 분석 ---------")
            print("구간 중간값 : \(adjustedSalary)")
            print("연간 소득 금액 : \(adjustedSalaryYearly)")
            print("근로 소득공제 : \(basicDeduction)")
            print("인적 공제 : \(familyDeduction)")
            print("연금보험료 공제 : \(pensionDeduction)")
            print("특별소득공제 등 : \(deductionOthers)")
            print("과세표준 : \(taxbasedSalary)")
            print("산출세액 : \(taxYearly)")
            print("근로소득 세액공제 : \(creditTax)")
            print("결정 세액 : \(taxYearlyFix)")
            print("간이 세액 : \(tax)")
        }
        return tax
    }
    
    /**
     * 연산기준 금액 산출
     * 정확히는 '소득구간 의 중간값 계산' 이다. 소득 이 아니라, 소득구간의 중간값으로 정산하게 된다. (간이 계산이라서 그런듯)
     *
     * 150만원 까지는 5000원 단위 간격
     * 300만원 까지는 10000원 단위 간격
     * 1000만원 까지는 20000원 단위 간격
     *
     */
    func getAdjustedSalary(_ _salary:Double )->Double
    {
        var salary : Double = 0
        if (_salary < 150 * 10000) {
            salary = roundDown(_salary,toNearest: 5000) + 2500

        } else if (_salary < 300 * 10000) {
            salary = roundDown(_salary,toNearest: 10000) + 5000
            
        } else if (_salary < 1000 * 10000) {
            salary = roundDown(_salary,toNearest: 20000) + 10000
        } else if (_salary == 1000 * 10000){
            salary = 1000 * 10000
        }
        return salary
    }
    
    /**
     * '근로 소득 공제' 금액 계산
     * 일종의 '기초 공제' 라고 볼 수 있다.
     *
     * 연간 기준 금액에 따른 차등적인 소득공제 를 한다.
     */
    func getBasicDeduction(_ incomeYearly : Double ) -> Double{
        
        // 근로소득 공제 금액
        var deduction : Double = 0;
        
        // 기준 금액의 구간별로 다른 공제요율로 공제금액이 계산된다.
        if (incomeYearly <= 500 * 10000) {
            deduction = incomeYearly * 0.7;
        } else if ( incomeYearly <= 1500 * 10000) {
            deduction = 350 * 10000 + ( incomeYearly - 500 * 10000) * 0.4;
        } else if ( incomeYearly <= 4500 * 10000) {
            deduction = 750 * 10000 + ( incomeYearly - 1500 * 10000) * 0.15;
        } else if ( incomeYearly <= 1 * 10000 * 10000) {
            deduction = 1200 * 10000 + ( incomeYearly - 4500 * 10000) * 0.05;
        } else {
            deduction = 1475 * 10000 + ( incomeYearly - 1 * 10000 * 10000) * 0.02;
        }
        
        return roundDown(deduction, toNearest: 1);
    }
    
    /**
    * 인적 공제
    * 공제대상가족 1명당 150만원 (공제대상가족 = 가족수 + 자녀수 (= 성인 + 자녀수 x 2배))
    */
    func getFamilyDeduction(family:Int, child:Int) -> Double
    {
        return Double(150 * 10000 * (family + child))
    }
    
    /**
     * 연금보험 공제
     * 12개월 분의 연금을 공제. 구간 중간 값으로 연금보험요액 을 재 계산 함.
     */
    func getPensionDeduction(_ income:Double) -> Double
    {
        var base : Double = 0
        if(income <= 29 * 10000){
            base = 29 * 10000
        } else if(income >= 449 * 10000){
            base = 449 * 10000
        } else {
            base = roundDown(income, toNearest: 1000)
        }
        return roundDown(base * 0.045, toNearest: 10) * 12
    }
    
    /**
     * 소득세 중 특별소득공제등
     *
     * @return
     */
    func getDeductionOthers(_ incomeYearly: Double, family:Int, child:Int) -> Double
    {
        var deduction : Double = 0
        let count : Int = family + child
        
        // 공제 대상자 수에 따른 공제
        if (count >= 3) { // 공제대상자 3명 이상인 경우
        
            if (incomeYearly <= 3000 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.07
            } else if (incomeYearly <= 4500 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.07 - (incomeYearly - 3000 * 10000) * 0.05
            }  else if (incomeYearly <= 7000 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.05
            } else if (incomeYearly <= 12000 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.03
            }
        
            // 추가공제
            if (incomeYearly >= 4000 * 10000)
            {
                deduction += (incomeYearly - 4000 * 10000) * 0.04
            }
            
        } else if(count == 2){ // 공제대상자 2명 인 경우
        
            if (incomeYearly <= 3000 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.04
            } else if (incomeYearly <= 4500 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.04 - (incomeYearly - 3000 * 10000) * 0.05
            } else if (incomeYearly <= 7000 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.02
            } else if (incomeYearly <= 12000 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.01
            }
        } else if(count == 1){
            
            if (incomeYearly <= 3000 * 10000) {
                deduction = 310 * 10000 + incomeYearly * 0.04
            } else if (incomeYearly <= 4500 * 10000) {
                deduction = 310 * 10000 + incomeYearly * 0.04 - (incomeYearly - 3000 * 10000) * 0.05
            } else if (incomeYearly <= 7000 * 10000) {
                deduction = 310 * 10000 + incomeYearly * 0.015
            } else if (incomeYearly <= 12000 * 10000) {
                deduction = 310 * 10000 + incomeYearly * 0.005
            }
        }
        return deduction
    }
    
    /**
     * 산출세액 계산 (소득세 최종 산출세엑, 세액공제 바로 전)
     *
     * 절삭 정책 : 원 단위 절삭 (이었다가 지금은 없어진 듯? 소수점만 절삭)
     * incomeYearly : 연간 과세표준 금액
     */
    func getIncomeTax(_ incomeYearly : Double) -> Double{
        var tax : Double = 0
    
        // 세금구간에 따라서, 소득세의 비율 차등 조정
        if (incomeYearly <= 1200 * 10000) {
            tax = incomeYearly * 0.06;
        } else if (incomeYearly <= 4600 * 10000) {
            tax = 72 * 10000 + (incomeYearly - 1200 * 10000) * 0.15;
        } else if (incomeYearly <= 8800 * 10000) {
            tax = 582 * 10000 + (incomeYearly - 4600 * 10000) * 0.24;
        } else if (incomeYearly <= 15000 * 10000) {
            tax = 1590 * 10000 + (incomeYearly - 8800 * 10000) * 0.35;
        } else if (incomeYearly <= 3 * 10000 * 10000) {
            tax = 3760 * 10000 + (incomeYearly - 15000 * 10000) * 0.38;
        } else if (incomeYearly <= 5 * 10000 * 10000) {
            tax = 9460 * 10000 + (incomeYearly - 30000 * 10000) * 0.40;
        } else {
            tax = 17460 * 10000 + (incomeYearly - 50000 * 10000) * 0.42;
        }
        return roundDown(tax, toNearest: 1);
    }
    
    /**
     * 근로소득 세액공제 계산
     *
     * 설명 : 세액 공제 란, 세금이 다 게산된 후에, 세금을 기준으로 공제를 해주는 방식입니다. 향후 세액 공제로 점점 추가되어갈 가능성이 높습니다. 이론상으로는 나쁘지 않으나, 실제로는 '세액 공제' 보다 '소득 공제' 가 여러가지면에서 혜택이 많습니다.
     * 절삭 정책 : 소수점 단위 절삭
     */
    func getCreditTax(_ incomeYearly : Double, taxYearly : Double) -> Double {
        var creditTax : Double = 0
        
        // 근로소득세액공제 처리
        if (taxYearly <= 50 * 10000) {
            creditTax = taxYearly * 0.55
        } else {
            creditTax = 275 * 1000 + (taxYearly - 50 * 10000) * 0.30
        }
    
        // 근로소득세액공제 한도 지정
        var maximum : Double = 0;
        if (incomeYearly <= 5500 * 10000) {
            maximum = 66 * 10000
        } else if (incomeYearly <= 7000 * 10000) {
            maximum = 63 * 10000
        } else if (incomeYearly > 7000 * 10000) {
            maximum = 50 * 10000
        }
        
        // 한도를 넘었을 시 한도 내로 재 지정
        if (creditTax > maximum) {
            creditTax = maximum;
        }
    
        return roundDown(creditTax, toNearest: 1)
    }
    
    /**
    * 고액의 경우
    * 1000만원인 경우의 세액 과 1000만원을 초과하는 금액에 98% 를 곱한 금액 중
    */
    func getHighAmountTax(_ salary: Double) -> Double
    {
        var amount : Double = salary
        var tax : Double = 0
        if(amount > 4500 * 10000){
            tax += (amount - 4500 * 10000) * 0.98 * 0.4
            amount = 4500 * 10000
        }
        
        if(amount > 1400 * 10000){
            tax += (amount - 1400 * 10000) * 0.98 * 0.38
            amount = 1400 * 10000
        }
        
        if(amount >= 1000 * 10000){
            tax += (amount - 1000 * 10000) * 0.98 * 0.35
            amount = 1000 * 10000
        }
        
        return tax
    }
    
    func reset()
    {
        incomeTax = 0
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



