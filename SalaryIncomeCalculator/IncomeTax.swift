//
//  IncomeTax.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import Foundation
class IncomeTax{
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
    
    /**
    * salary : 월봉
    *
    */
    func calculate(_ salary: Double, family: Int, child: Int, nationalPension: Double)
    {
       
        // 1. 구간별 액수 조정 (구간별 잔액 처리)
        var adjustedSalary : Double = getAdjustedSalary(salary)
 
        // 2. 연간 근로소득금액 산출 : 연간 소득 - 연간 근로소득 공제 (기초공제)
        var adjustedSalaryYearly : Double = adjustedSalary * 12
        adjustedSalaryYearly -= getBasicDeduction(adjustedSalaryYearly) //연간 소득 - 연간 소득 공제
        
        // 3. 종합소득공제 산출 (인적공제, 연금보험공제, 특별소득공제 등)
        var integratedDeduction : Double = getIntegratedDeduction(adjustedSalary*12, family: family, child: child, nationalPension: nationalPension)
        
        // 4. 과세표준 산출
        var taxbasedSalary : Double = adjustedSalaryYearly - integratedDeduction
        
        // 5. 결정세액 산출 (연간 결정세액 = 연간 산출세엑 - 연간 세액 공제)
        var taxYearly : Double = getIncomeTax(taxbasedSalary)
        taxYearly -= getCreditTax(adjustedSalaryYearly, taxYearly: taxYearly)
        
        /**
         * 6. 간이세액 산출
         * 설명 : 왜 간이세액 이냐면, 한달은 정확히 30일이 아니기 때문이다. 상세하게 하려면 일자 를 계산해서 정산한다.
         * 월간 간이세액 = 연간 결정세액 / 12
         * 절삭정책 : 원 단위 절사
         */
        incomeTax = roundDown( taxYearly/12, toNearest: 10)
    }
    
    /**
     * 연산기준 금액 산출
     *
     * 150만원 까지는 5000원 단위 간격
     * 300만원 까지는 10000원 단위 간격
     * 1000만원 까지는 20000원 단위 간격
     *
     */
    func getAdjustedSalary(_ _salary:Double )->Double
    {
        var salary : Double = 0
        if (_salary <= 150 * 10000) {
            salary = roundDown(_salary,toNearest: 5000) + 2500

        } else if (_salary <= 300 * 10000) {
            salary = roundDown(_salary,toNearest: 10000) + 5000
            
        } else if (_salary <= 1000 * 10000) {
            salary = roundDown(_salary,toNearest: 20000) + 10000
            
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
     * 종합소득공제 산출
     *
     * 인적공제, 연금보험료공제, 특별소득공제 등 의 합계를 반환
     * 주의 : 이 공제 계산식이 틀리면, 전체적으로 틀어지므로. 간이세액표 를 활용하는 것이 좋을 때도 있다.
     *
     */
    func getIntegratedDeduction(_ incomeYearly:Double, family:Int, child:Int, nationalPension: Double) -> Double
    {
        // 1) 인적공제
        let familyDeduction : Double = Double(150 * 10000 * (family + child));

        // 2) 연금보험 공제
        let pensionDeduction : Double = nationalPension * 12;
       
        // 3) 특별소득공제
        let deductionOthers : Double = getDeductionOthers(incomeYearly, family:family, child:child)
        
        return familyDeduction + pensionDeduction + deductionOthers;
    }
    
    /**
     * 소득세 중 특별소득공제등
     *
     * @return
     */
    func getDeductionOthers(_ incomeYearly: Double, family:Int, child:Int) -> Double
    {
        var deduction : Double = 0
    
        // 공제 대상자 수에 따른 공제
        if (family + child >= 3) { // 공제대상자 3명 이상인 경우
        
            if (incomeYearly <= 3000 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.07
            } else if (incomeYearly <= 4500 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.07 - (incomeYearly - 3000 * 10000) * 0.05
            }  else if (incomeYearly <= 7000 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.05
            } else if (incomeYearly <= 12000 * 10000) {
                deduction = 500 * 10000 + incomeYearly * 0.03
            } else {
                deduction = 0
            }
        
            // 추가공제
            if (incomeYearly >= 4000)
            {
                deduction += (incomeYearly - 4000 * 10000) * 0.04
            }
            
        } else { // 공제대상자 2명 이하인 경우
        
            if (incomeYearly <= 3000 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.04
            } else if (incomeYearly <= 4500 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.04 - (incomeYearly - 3000 * 10000) * 0.05
            } else if (incomeYearly <= 7000 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.02
            } else if (incomeYearly <= 12000 * 10000) {
                deduction = 360 * 10000 + incomeYearly * 0.01
            } else {
                deduction = 0
            }
        }
        return deduction
    }
    
    /**
     * 산출세엑 계산 (소득세 최종 산출세엑, 세액공제 바로 전)
     *
     * 절삭 정책 : 원 단위 절삭
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
        } else {
            tax = 3760 * 10000 + (incomeYearly - 15000 * 10000) * 0.38;
        }
        return roundDown(tax, toNearest: 10);
    }
    
    /**
     * 세액 공제 계산
     *
     * 설명 : 세액 공제 란, 세금이 다 게산된 후에, 세금을 기준으로 공제를 해주는 방식입니다. 향후 세액 공제로 점점 추가되어갈 가능성이 높습니다. 이론상으로는 나쁘지 않으나, 실제로는 '세액 공제' 보다 '소득 공제' 가 여러가지면에서 혜택이 많습니다.
     * 절삭 정책 : 원 단위 절삭
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
            maximum = 660000
        } else if (incomeYearly <= 7000 * 10000) {
            maximum = 630000
        } else if (incomeYearly > 7000 * 10000) {
            maximum = 500000
        }
        
        // 한도를 넘었을 시 한도 내로 재 지정
        if (creditTax > maximum) {
            creditTax = maximum;
        }
    
        return roundDown(creditTax, toNearest: 10)
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
