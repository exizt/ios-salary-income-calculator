//
//  FirstViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FirstViewController: UIViewController, UITextFieldDelegate,GADInterstitialDelegate {
    @IBOutlet weak var resultSummary: UILabel!
    @IBOutlet weak var inMoney: UITextField!
    @IBOutlet weak var inTaxFree: UITextField!
    @IBOutlet weak var resultDetail: UILabel!
    @IBOutlet weak var iSegmentedAnnual: UISegmentedControl!

    let calculator : SalaryCalculator = SalaryCalculator()
    var interstitial : GADInterstitial!
    
    /**
    * 기본 메서드.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interstitial = createAndLoadInterstitial()
        
        viewDidLoad_keyboardDone()

        inMoney.addTarget(self, action: #selector(self.textFieldDidChanged_inMoney), for: .editingChanged)
        inTaxFree.addTarget(self, action: #selector(self.textFieldDidChange_inTaxFree), for: .editingChanged)
        iSegmentedAnnual.addTarget(self, action: #selector(self.iSegmentedAnnual_valueChanged), for: .valueChanged)
    }

    func createAndLoadInterstitial() -> GADInterstitial?{
        let interstitialGAD = GADInterstitial(adUnitID: "ca-app-pub-6702794513299112/1093139381")
        interstitialGAD.delegate = self
        
        
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID,                    // all simulators
                                "d73c08aad93622d32f26c3522eb69135" ] // SHiPhone7
        interstitialGAD.load(request)
        
        return interstitialGAD
    }
    
    func viewInterstitial(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
    
    /**
    * 기본 메서드.
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    * 계산 메서드. 이 메서드로 호출해주자.
    */
    func loadCalculation()
    {
        guard let incomeMoney = Double((inMoney?.text!)!) else {
            return
        }
        
        // 금액 입력이 10만원 이내면 계산안함
        if(incomeMoney < 10 * 0000){
            return
        }
        
        guard let incomeTaxFree = Double((inTaxFree?.text!)!) else {
            return
        }
        
        let isAnnualIncome = (iSegmentedAnnual.selectedSegmentIndex == 0) ? true : false
        
        
        let options = SalaryCalculatorOptions()
        options.money = incomeMoney
        options.family = 1
        options.child = 0
        options.taxFree = incomeTaxFree
        options.isAnnualIncome = isAnnualIncome
        
        if(!calculator.Options().equals(options)){
            // 계산 메서드 호출
            calculate(options)
        }
    }
    
    /**
    * 계산 메서드.
    * 가급적 바로 호출하지 마시고, loadCalculation 메서드로 호출해주세요.
    * 테스트 할 시에만 직접 호출 하세요.
    */
    func calculate(_ options : SalaryCalculatorOptions) {
        
        calculator.setOptions(options)
        calculator.calculate()
        
        /**
        * 계산 결과 처리
        */
        //resultSummary.text = String(format:"%f",formatter.string(from:calculator.netSalary))
        resultSummary.text = formatCurrency(calculator.netSalary) + " 원"
        //resultSummary.text = "adasdf"
        
        var insurance = Insurance()
        insurance = calculator.getInsurance()
        
        var incomeTax = IncomeTax()
        incomeTax = calculator.getIncomeTax()
        
        resultDetail.text = String(format:"국민연금 : %@ 원 \r\n건강보험 : %@ 원 \r\n요양보험 : %@ 원 \r\n고용보험 : %@ 원 \r\n소득세 : %@ 원 \r\n지방세 : %@ 원",formatCurrency(insurance.nationalPension),formatCurrency(insurance.healthCare),formatCurrency(insurance.longTermCare),formatCurrency(insurance.employmentCare),formatCurrency(incomeTax.incomeTax),formatCurrency(incomeTax.localTax))
    }
    
    /**
    * 금액 입력 시 메서드
    */
    func textFieldDidChanged_inMoney(_ sender: UITextField) {
        guard let incomeMoney = Double((sender.text!)) else {
            return
        }
        
        if(incomeMoney < 100000)
        {
            return
        }
        
        if(incomeMoney>=10000000){
            self.iSegmentedAnnual.selectedSegmentIndex = 0
        } else {
            self.iSegmentedAnnual.selectedSegmentIndex = 1
        }
        
        // 계산 호출
        loadCalculation()
    }
    
    /**
     * 비과세 입력 시 메서드
     */
    func textFieldDidChange_inTaxFree(_ sender: UITextField){
        let isDebug = true
        
        if(isDebug){
            print("Testing!")
            guard let text = Double((sender.text!)) else {
                return
            }
            print(text)
        }
        
        // 계산 호출
        loadCalculation()
    }
    
    func iSegmentedAnnual_valueChanged(_ sender: UISegmentedControl){
        //print("Segmented 변경됨")
        loadCalculation()
    }
    
    /**
     * 키보드 바로 위에 [Done] 추가하는 메서드
     */
    func viewDidLoad_keyboardDone()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.keyboard_doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        //textfield 가 필요하면 여기에 추가
        inMoney.inputAccessoryView = toolBar
        inTaxFree.inputAccessoryView = toolBar
    }
    
    
    /**
     * 키보드 바로 위의 [Done] 클릭시 에 행동하는 메서드
     */
    func keyboard_doneClicked()
    {
        view.endEditing(true)
    }
    
    /**
    * 2000 (Double) -> 2,000 (String)
    * 숫자를 금액처럼 , 넣고 변경해주는 메서드
    */
    func formatCurrency(_ value: Double)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
}

