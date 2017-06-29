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
    let calculator : SalaryCalculator = SalaryCalculator()
    let calculatorOptions : SalaryCalculatorOptions = SalaryCalculatorOptions()
    var interstitial : GADInterstitial!

    @IBOutlet weak var resultSummary: UILabel!
    @IBOutlet weak var inMoney: UITextField!
    @IBOutlet weak var viewFamily: UILabel!
    @IBOutlet weak var inTaxFree: UITextField!
    @IBOutlet weak var resultDetail: UILabel!
    @IBOutlet weak var iSegmentedAnnual: UISegmentedControl!
    @IBOutlet weak var lblChild: UILabel!
    @IBOutlet weak var lblFamily: UILabel!

    // 기본 메서드
    // 로드 된 직후 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interstitial = createAndLoadInterstitial()
        
        viewDidLoad_keyboardDone()

        inMoney.addTarget(self, action: #selector(self.textFieldDidChanged_inMoney), for: .editingChanged)
        inTaxFree.addTarget(self, action: #selector(self.textFieldDidChange_inTaxFree), for: .editingChanged)
        iSegmentedAnnual.addTarget(self, action: #selector(self.iSegmentedAnnual_valueChanged), for: .valueChanged)
    }

    @IBAction func stepperFamily_valueChanged(_ sender: UIStepper) {
        lblFamily.text = String(format: "가족수 %d 명", Int(sender.value))
        calculatorOptions.family = Int(sender.value)
        loadCalculation()
    }
    
    @IBAction func stepperChild_valueChanged(_ sender: UIStepper) {
        lblChild.text = String(format: "자녀수 %d 명", Int(sender.value))
        calculatorOptions.child = Int(sender.value)
        loadCalculation()
    }
    
    // 기본 메서드
    // 메모리 워닝 관련
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    * 계산 메서드. 이 메서드로 호출해주자.
    */
    func loadCalculation()
    {
        let incomeMoney = calculatorOptions.money

        // 금액 입력이 10만원 이내면 계산안함
        if(incomeMoney < 10 * 10000){
            return
        }
        
        if(!calculator.Options().equals(calculatorOptions)){
            // 계산 메서드 호출
            calculate(calculatorOptions)
        }
    }
    
    /**
    * 계산 메서드.
    * 가급적 바로 호출하지 마시고, loadCalculation 메서드로 호출해주세요.
    * 테스트 할 시에만 직접 호출 하세요.
    */
    func calculate(_ _options : SalaryCalculatorOptions) {
        print(_options.toString())
        
        // 설정값 대입
        calculator.Options().money = _options.money
        calculator.Options().family = _options.family
        calculator.Options().child = _options.child
        calculator.Options().taxFree = _options.taxFree
        calculator.Options().isAnnualIncome = _options.isAnnualIncome
        calculator.Options().isIncludedSeverance = _options.isIncludedSeverance
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
            calculatorOptions.money = 0
            return
        }
        calculatorOptions.money = incomeMoney
        
        if(incomeMoney < 100000)
        {
            return
        }
        
        //1000만원 보다 크면 연봉으로 감안, 적으면 월급으로 감안
        if(incomeMoney>=10000000){
            self.iSegmentedAnnual.selectedSegmentIndex = 0
            calculatorOptions.isAnnualIncome  = true
        } else {
            self.iSegmentedAnnual.selectedSegmentIndex = 1
            calculatorOptions.isAnnualIncome  = false
        }
        
        // 계산 호출
        loadCalculation()
    }
    
    /**
     * 비과세 입력 시 메서드
     */
    func textFieldDidChange_inTaxFree(_ sender: UITextField){
        guard let taxFree = Double((sender.text!)) else {
            calculatorOptions.taxFree = 0
            return
        }
        calculatorOptions.taxFree = taxFree
        
        
        // 계산 호출
        loadCalculation()
    }
    
    func iSegmentedAnnual_valueChanged(_ sender: UISegmentedControl){
        //print("Segmented 변경됨")
        calculatorOptions.isAnnualIncome  = (sender.selectedSegmentIndex == 0) ? true : false
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
    
    // Admob 전면광고 생성 메서드
    func createAndLoadInterstitial() -> GADInterstitial?{
        var testDevices : [Any] = []
        testDevices += [kGADSimulatorID] // all simulators
        testDevices += ["d73c08aad93622d32f26c3522eb69135"] // SHiPhone7

        //Admob Unit ID
        let interstitialGAD = GADInterstitial(adUnitID: "ca-app-pub-6702794513299112/1093139381")
        interstitialGAD.delegate = self
        
        
        let request = GADRequest()
        request.testDevices = testDevices
        interstitialGAD.load(request)
        
        return interstitialGAD
    }
    
    //Admob 전면광고
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
}

