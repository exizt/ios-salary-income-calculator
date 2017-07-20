//
//  CalculatorViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 15..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//  동작 과정 설명
//  calculatorOptions 는 클래스인데, 입력을 받기 위한 오브젝트가 있고, salaryCalculator 내의 멤버변수로도 Option 객체가 있다. 같은 형태인데, 둘이 레퍼런스 참조가 되지 않도록, 값으로 넘겨주어야 한다. (반드시 주의) 객체로 넘기게 되면 레퍼런스 참조가 되면서 구현이 엉킬 수 있음.
//

import UIKit

class CalculatorMaster_ViewController: UITableViewController, UITextFieldDelegate{
    let calculator : SalaryCalculator = SalaryCalculator()
    let calculatorOptions : SalaryCalculatorOptions = SalaryCalculatorOptions()
    let isDebug = false
    
    // calculator option object
    @IBOutlet weak var in_Option_Money : UITextField!
    @IBOutlet weak var in_Option_Taxfree : UITextField!
    @IBOutlet weak var in_Option_Stepper_Family: UIStepper!
    @IBOutlet weak var in_Option_Stepper_Child: UIStepper!
    @IBOutlet weak var in_Option_Segmented_Annual : UISegmentedControl!
    @IBOutlet weak var in_Option_IncSev: UISwitch!
    // calculator label
    @IBOutlet weak var lbl_Option_Family : UILabel!
    @IBOutlet weak var lbl_Option_Child : UILabel!
    // input money support button
    @IBOutlet weak var btn_money_plus100: UIButton!
    @IBOutlet weak var btn_money_plus1000: UIButton!
    @IBOutlet weak var btn_money_reset: UIButton!
    @IBOutlet weak var btn_money_plus10: UIButton!
    // calculator reslut label
    @IBOutlet weak var lbl_Result_NetSalary : UILabel!
    @IBOutlet weak var lbl_ResultDetail_NP: UILabel!
    @IBOutlet weak var lbl_ResultDetail_HC: UILabel!
    @IBOutlet weak var lbl_ResultDetail_LTC : UILabel!
    @IBOutlet weak var lbl_ResultDetail_EC: UILabel!
    @IBOutlet weak var lbl_ResultDetail_IncomeTax : UILabel!
    @IBOutlet weak var lbl_ResultDetail_LocalTax : UILabel!
    
    // load 와 관련된 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드에 done 버튼 추가
        registerDoneWithKeyboard()
        
        self.tableView.allowsSelection = false
        
        // textfield 이벤트
        in_Option_Money.addTarget(self, action: #selector(self.textFieldMoney_didChanged(_:)), for: .editingChanged)
        in_Option_Taxfree.addTarget(self, action: #selector(self.textFieldTaxfree_didChanged(_:)), for: .editingChanged)
        
        // stepper 이벤트
        in_Option_Stepper_Family.addTarget(self, action: #selector(self.stepperFamily_valueChanged(_:)), for: .valueChanged)
        in_Option_Stepper_Child.addTarget(self, action: #selector(self.stepperChild_valueChanged(_:)), for: .valueChanged)
        
        // 선택 이벤트
        in_Option_Segmented_Annual.addTarget(self, action: #selector(self.iSegmentedAnnual_valueChanged(_:)), for: .valueChanged)
        in_Option_IncSev.addTarget(self, action: #selector(self.switchIncSev_valueChanged(_:)), for: .valueChanged)
        
        // 금액 입력 도우미
        btn_money_reset.addTarget(self, action: #selector(self.btnHandleMoney), for: .touchUpInside)
        btn_money_plus10.addTarget(self, action: #selector(self.btnHandleMoney), for: .touchUpInside)
        btn_money_plus100.addTarget(self, action: #selector(self.btnHandleMoney), for: .touchUpInside)
        btn_money_plus1000.addTarget(self, action: #selector(self.btnHandleMoney), for: .touchUpInside)
        
        // 결과 초기화
        resetCalculatorResult()
        
        // 설정
        in_Option_Stepper_Family.maximumValue = 59
        in_Option_Stepper_Family.minimumValue = 1
        in_Option_Stepper_Child.maximumValue = 30
        in_Option_Stepper_Child.minimumValue = 0
        in_Option_Money.keyboardType = UIKeyboardType.numberPad
        in_Option_Taxfree.keyboardType = UIKeyboardType.numberPad
        
        // 환경 설정 값 가져오기
        getDefaultOptions()
        
        // 옵션값 전부 확인
        //print(UserDefaults.standard.dictionaryRepresentation())
        
        in_Option_Money.delegate = self
        in_Option_Taxfree.delegate = self
        
    }
    func btnHandleMoney(_ sender: UIButton!){
        guard var inMoney = Double((in_Option_Money.text!)) else {
            //calculatorOptions.money = 0
            return
        }
        
        if(sender.tag == 10){
            inMoney += 100000.0
        } else if(sender.tag == 100){
            inMoney += 1000000.0
        } else if (sender.tag == 1000){
            inMoney += 10000000.0
        } else if (sender.tag == 0){
            calculatorOptions.money = 0
            in_Option_Money.text = "0"
            calculator.Options().money = 0
            resetCalculatorResult()
            return
        }
        calculatorOptions.money = inMoney
        in_Option_Money.text = String(Int(inMoney))
        autoChangeAnnualyFromIncomeMoney(inMoney)
        
        loadCalculation()
    }
    
    // 메모리 워닝 관련 (기본 메서드)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 화면이 드로잉 될때마다 호출됨 (매번 호출됨)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 설정 변경 되면, 변경된 값 적용시켜야 함.
        // 물어보고 적용하는 방식이어야 할 듯
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 옵션에서 변경된 세율을 적용시키는 메서드
        setInsuranceRateFromOption()
    }
    
    // 가족수 +-
    func stepperFamily_valueChanged(_ sender: UIStepper) {
        updateCalcOption_Family()
        loadCalculation()
    }
    
    // 자녀수 +-
    func stepperChild_valueChanged(_ sender: UIStepper) {
        lbl_Option_Child.text = String(format: "자녀수 %d 명", Int(sender.value))
        calculatorOptions.child = Int(sender.value)
        loadCalculation()
    }
    
    // 금액 입력 시 메서드
    func textFieldMoney_didChanged(_ sender: UITextField) {
        guard let incomeMoney = Double((sender.text!)) else {
            calculatorOptions.money = 0
            return
        }
        calculatorOptions.money = incomeMoney
        if(incomeMoney < 100000)
        {
            return
        }
        
        // 금액 기준으로 연/월 급 선택 자동 변경
        autoChangeAnnualyFromIncomeMoney(incomeMoney)
        
        // 계산 호출
        loadCalculation()
    }
    
    func autoChangeAnnualyFromIncomeMoney(_ money: Double){
        //1000만원 보다 크면 연봉으로 감안, 적으면 월급으로 감안
        if(money>=10000000){
            self.in_Option_Segmented_Annual.selectedSegmentIndex = 0
            calculatorOptions.isAnnualIncome  = true
        } else {
            self.in_Option_Segmented_Annual.selectedSegmentIndex = 1
            calculatorOptions.isAnnualIncome  = false
        }
    }
    
    // 비과세 입력 시 메서드
    func textFieldTaxfree_didChanged(_ sender: UITextField){
        guard (Double((sender.text!)) != nil) else {
            return
        }
        updateCalcOption_Taxfree()
        
        // 계산 호출
        loadCalculation()
    }
    
    //
    func iSegmentedAnnual_valueChanged(_ sender: UISegmentedControl){
        //print("Segmented 변경됨")
        calculatorOptions.isAnnualIncome  = (sender.selectedSegmentIndex == 0) ? true : false
        loadCalculation()
    }
    
    func switchIncSev_valueChanged(_ sender: UISwitch) {
        //calculatorOptions.isIncludedSeverance = sender.val
        calculatorOptions.isIncludedSeverance = (sender.isOn) ? true: false
        loadCalculation()
    }
    
    // 환경설정에서 설정한 기본입력값을 셋팅
    func getDefaultOptions(){
        // 환경 설정이 안되어 있을 때 최초 1회 지정
        registerDefaultOptions()
        
        //print("[SH Debugger] FirstViewController getDefaultOptions "+MyAppSettings.InputDefaults.family.getValue())
        
        in_Option_Stepper_Family.value = Double(SHNUserSettings.InputDefaults.family.getValue())!
        updateCalcOption_Family()
        
        in_Option_Stepper_Child.value = Double(SHNUserSettings.InputDefaults.child.getValue())!
        updateCalcOption_Child()
        
        in_Option_Taxfree.text = SHNUserSettings.InputDefaults.taxfree.getValue()
        updateCalcOption_Taxfree()
        
        in_Option_IncSev.setOn(SHNUserSettings.InputDefaults.includedSev.bool(), animated: true)
        
        
    }
    
    // 옵션에서 지정한 세율을 적용한다.
    func setInsuranceRateFromOption()
    {
        if(SHNUserSettings.Advanced.isEnableCustomRate.bool()){
            let rates = InsuranceRate.init(_nationalPension: SHNUserSettings.Rates.nationalPension.double(), _healthCare: SHNUserSettings.Rates.healthCare.double(), _longTermCare: SHNUserSettings.Rates.longTermCare.double(), _employmentCare: SHNUserSettings.Rates.employmentCare.double())
            
            calculator.setInsuranceRate(rates)
        } else {
            let rates = InsuranceRate()
            calculator.setInsuranceRate(rates)
        }
    }
    
    // 설정이 되어있지 않았을 때 최초 1회만 실행한다.
    func registerDefaultOptions(){
        /**
         * 순서대로
         * 1) 국민연금 요율
         * 2)건강보험 요율
         * 3)요양보험 요율
         * 4)고용보험 요율
         */
        let defaults = [
            SHNUserSettings.Rates.nationalPension.key():4.5,
            SHNUserSettings.Rates.healthCare.key():3.06,
            SHNUserSettings.Rates.longTermCare.key():6.55,
            SHNUserSettings.Rates.employmentCare.key():0.65,
            SHNUserSettings.InputDefaults.family.key():1,
            SHNUserSettings.InputDefaults.child.key():0,
            SHNUserSettings.InputDefaults.taxfree.key():100000,
            SHNUserSettings.InputDefaults.includedSev.key():false,
            SHNUserSettings.Advanced.isEnableCustomRate.key():false
            ] as [String : Any]
        UserDefaults.standard.register(defaults: defaults)
    }
    
    
    
    // 계산 메서드. 이 메서드로 호출해주자.
    func loadCalculation()
    {
        
        let incomeMoney = calculatorOptions.money
        
        // 금액 입력이 10만원 이내면 계산안함
        if(incomeMoney < 10 * 10000){
            return
        }
        
        //debugPrint(String(format: "before calculator options [%f]", calculatorOptions.money))
        //debugPrint(String(format: "after  inOptions Money [%f]", calculatorOptions.money))
        
        debugPrint("calculator Before Options "+calculator.Options().toString())
        debugPrint("inOptions "+calculatorOptions.toString())
        if(!calculator.Options().equals(calculatorOptions)){
            
            // 계산 메서드 호출
            calculate(calculatorOptions)
        }
    }
    
    // 계산 메서드.
    // 가급적 바로 호출하지 마시고, loadCalculation 메서드로 호출해주세요.
    // 테스트 할 시에만 직접 호출 하세요.
    func calculate(_ _options : SalaryCalculatorOptions) {
        debugPrint("calculate actived")
        //debugPrint("inOptions "+_options.toString())
        
        // 설정값 대입
        calculator.Options().money = _options.money
        calculator.Options().family = _options.family
        calculator.Options().child = _options.child
        calculator.Options().taxFree = _options.taxFree
        calculator.Options().isAnnualIncome = _options.isAnnualIncome
        calculator.Options().isIncludedSeverance = _options.isIncludedSeverance
        
        //debugPrint("calculator Options "+calculator.Options().toString())
        
        calculator.calculate()
        
        calculate_result()
    }
    
    // 결과 처리
    func calculate_result(){
        debugPrint("cacluate_result actived")
        if(!calculator.isSuccess()){
            resetCalculatorResult()
            return
        }
        /**
         * 계산 결과 처리
         */
        lbl_Result_NetSalary.text = formatCurrency(calculator.netSalary) + " 원"
        
        var insurance = Insurance()
        insurance = calculator.getInsurance()
        
        var incomeTax = IncomeTax()
        incomeTax = calculator.getIncomeTax()
        
        // 상세 결과 표현
        lbl_ResultDetail_NP.text = formatCurrency(insurance.nationalPension) + " 원"
        lbl_ResultDetail_HC.text = formatCurrency(insurance.healthCare) + " 원"
        lbl_ResultDetail_LTC.text = formatCurrency(insurance.longTermCare) + " 원"
        lbl_ResultDetail_EC.text = formatCurrency(insurance.employmentCare) + " 원"
        lbl_ResultDetail_IncomeTax.text = formatCurrency(incomeTax.incomeTax) + " 원"
        lbl_ResultDetail_LocalTax.text = formatCurrency(incomeTax.localTax) + " 원"
    }
    
    
    // 결과 초기화
    func resetCalculatorResult(){
        debugPrint("resetCalculatorResult actived")
        
        // 실수령액 결과
        lbl_Result_NetSalary.text = "0 원"
        
        // 입력값 초기화
        //in_Option_Money.text = "0"
        
        // 실수령액 상세 결과
        lbl_ResultDetail_NP.text = "0 원"
        lbl_ResultDetail_HC.text = "0 원"
        lbl_ResultDetail_LTC.text = "0 원"
        lbl_ResultDetail_EC.text = "0 원"
        lbl_ResultDetail_IncomeTax.text = "0 원"
        lbl_ResultDetail_LocalTax.text = "0 원"
        
    }
    
    func updateCalcOption_Family(){
        let value = Int(in_Option_Stepper_Family.value)
        
        lbl_Option_Family.text = String(format: "가족수 %d 명", value)
        calculatorOptions.family = value
    }
    
    func updateCalcOption_Child(){
        let value = Int(in_Option_Stepper_Child.value)
        
        lbl_Option_Child.text = String(format: "자녀수 %d 명", value)
        calculatorOptions.child = value
    }
    
    func updateCalcOption_Taxfree(){
        guard let value = Double(in_Option_Taxfree.text!) else {
            return
        }
        calculatorOptions.taxFree = value
    }
    
    /**
     * 키보드 바로 위에 [Done] 추가하는 메서드
     */
    func registerDoneWithKeyboard()
    {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.keyboard_doneClicked))
        
        doneToolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        //textfield 가 필요하면 여기에 추가
        in_Option_Money.inputAccessoryView = doneToolbar
        in_Option_Taxfree.inputAccessoryView = doneToolbar
    }
    
    /**
     * 키보드 바로 위의 [Done] 클릭시 에 행동하는 메서드
     */
    func keyboard_doneClicked()
    {
        view.endEditing(true)
    }
    
    // 2000 (Double) -> 2,000 (String)
    // 숫자를 금액처럼 , 넣고 변경해주는 메서드
    func formatCurrency(_ value: Double)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
    
    // textfield 길이 제한을 하기 위한 메서드. TextfieldDelegate 를 필요로 한다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("count textfield")
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10
    }
    
    func debugPrint(_ message:String){
        if(isDebug){
            print("[Calculator]"+message)
        }
    }
    
    
    // 네비게이션 컨트롤러를 통해서 하위 액티비티 를 부르기 전에 동작하는 메서드.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //debugPrint("CalculatorMaster prepare")
        let cell = sender as! UITableViewCell
        //let receiveItem: CalculatorDetail_ViewController_Receive
        
        switch String(segue.identifier ?? "")! {
        case "segue_detail_np":
            prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.np)
            break
        case "segue_detail_hc":
            prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.hc)
            break
        case "segue_detail_ltc":
            prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.ltc)
            break
        case "segue_detail_ec":
            prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.ec)
            break
        case "segue_detail_incomeTax":
            //prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.incomeTax)
            break
        case "segue_detail_localTax":
            //prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.localTax)
            break
        case "segue_select_np":
            debugPrint("국민연금 셀 선택")
            //prepare_detailView(cell,destination: segue.destination,receiveItem:CalculatorDetail_ViewController_Receive.localTax)
            break
        default:
            //receiveItem = CalculatorDetail_ViewController_Receive.np
            debugPrint(String(segue.identifier ?? "")!)
            break
        }
        
        //let view = segue.destination as! CalculatorDetail_ViewController
        //view.title = ((cell.textLabel)?.text)!
        //view.receiveItem(receiveItem)
        
    }
    func prepare_detailView(_ cell: UITableViewCell, destination: Any, receiveItem: CalculatorDetail_ViewController_Receive){
        let view = destination as! CalculatorDetail_ViewController
        view.title = ((cell.textLabel)?.text)!
        view.receiveItem(receiveItem)
    }
}
