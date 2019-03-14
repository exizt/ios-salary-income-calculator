//
//  FirstViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FirstViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate, GADBannerViewDelegate {
    let calculator : SalaryCalculator = SalaryCalculator()
    let calculatorOptions : SalaryCalculatorOptions = SalaryCalculatorOptions()
    var interstitialAD : GADInterstitial!
    var bannerViewAD: GADBannerView!
    let isEnabled_InterstitialAD: Bool = false
    let isEnabled_BannerAD: Bool = true

    @IBOutlet weak var in_Option_Money : UITextField!
    @IBOutlet weak var in_Option_Taxfree : UITextField!
    @IBOutlet weak var in_Option_Stepper_Family: UIStepper!
    @IBOutlet weak var in_Option_Stepper_Child: UIStepper!
    @IBOutlet weak var in_Option_Segmented_Annual : UISegmentedControl!
    @IBOutlet weak var in_Option_IncSev: UISwitch!
    @IBOutlet weak var resultDetail : UILabel!
    @IBOutlet weak var lbl_Result_NetSalary : UILabel!
    @IBOutlet weak var lbl_Option_Family : UILabel!
    @IBOutlet weak var lbl_Option_Child : UILabel!
    @IBOutlet weak var lbl_ResultDetail_NP: UILabel!
    @IBOutlet weak var lbl_ResultDetail_HC: UILabel!
    @IBOutlet weak var lbl_ResultDetail_LTC : UILabel!
    @IBOutlet weak var lbl_ResultDetail_EC: UILabel!
    @IBOutlet weak var lbl_ResultDetail_IncomeTax : UILabel!
    @IBOutlet weak var lbl_ResultDetail_LocalTax : UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackViewMaster: UIStackView!

    
    // 로드 된 직후 호출 (기본 메서드)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(isEnabled_InterstitialAD) { interstitialAD = createAndLoadInterstitial() }
        if(isEnabled_BannerAD) { initAdmobBanner() }
      
        initColor()
        
        addDoneButtonOnKeyboard()
        registerDefaultOptions()

        // textfield 이벤트
        in_Option_Money.addTarget(self, action: #selector(self.textFieldMoney_didChanged(_:)), for: .editingChanged)
        in_Option_Taxfree.addTarget(self, action: #selector(self.textFieldTaxfree_didChanged(_:)), for: .editingChanged)
        
        // stepper 이벤트
        in_Option_Stepper_Family.addTarget(self, action: #selector(self.stepperFamily_valueChanged(_:)), for: .valueChanged)
        in_Option_Stepper_Child.addTarget(self, action: #selector(self.stepperChild_valueChanged(_:)), for: .valueChanged)
        
        // 선택 이벤트
        in_Option_Segmented_Annual.addTarget(self, action: #selector(self.iSegmentedAnnual_valueChanged(_:)), for: .valueChanged)
        
        in_Option_IncSev.addTarget(self, action: #selector(self.switchIncSev_valueChanged(_:)), for: .valueChanged)
        
        //
        initDisplayValues()
        
        //
        setDefaultInputValues()
        
        // 옵션값 전부 확인
        //print(UserDefaults.standard.dictionaryRepresentation())
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        in_Option_Money.delegate = self
        in_Option_Taxfree.delegate = self
    }

    func initColor(){
        //view.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        //view.backgroundColor = UIColorFromRGBA(R: 78, G: 138, B: 199, alpha: 1.0)
        //view.color
        //view.tintColor = UIColorFromRGBA(R: 255, G: 255, B: 255, alpha: 1.0)
        //view.tintColor = .red
        //view.tintColor = .white
        
    }
    
    // 메모리 워닝 관련 (기본 메서드)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    //
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackViewMaster.frame.width, height: stackViewMaster.frame.height)
    }
    
    // 가족수 +-
    @objc func stepperFamily_valueChanged(_ sender: UIStepper) {
        updateCalcOption_Family()
        loadCalculation()
    }

    // 자녀수 +-
    @objc func stepperChild_valueChanged(_ sender: UIStepper) {
        lbl_Option_Child.text = String(format: "자녀수 %d 명", Int(sender.value))
        calculatorOptions.child = Int(sender.value)
        loadCalculation()
    }
    
    // 금액 입력 시 메서드
    @objc func textFieldMoney_didChanged(_ sender: UITextField) {
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
            self.in_Option_Segmented_Annual.selectedSegmentIndex = 0
            calculatorOptions.isAnnualIncome  = true
        } else {
            self.in_Option_Segmented_Annual.selectedSegmentIndex = 1
            calculatorOptions.isAnnualIncome  = false
        }
        
        // 계산 호출
        loadCalculation()
    }
    
    // 비과세 입력 시 메서드
    @objc func textFieldTaxfree_didChanged(_ sender: UITextField){
        guard (Double((sender.text!)) != nil) else {
            return
        }
        updateCalcOption_Taxfree()
        
        // 계산 호출
        loadCalculation()
    }
    
    //
    @objc func iSegmentedAnnual_valueChanged(_ sender: UISegmentedControl){
        //print("Segmented 변경됨")
        calculatorOptions.isAnnualIncome  = (sender.selectedSegmentIndex == 0) ? true : false
        loadCalculation()
    }
    
    @objc func switchIncSev_valueChanged(_ sender: UISwitch) {
        //calculatorOptions.isIncludedSeverance = sender.val
        calculatorOptions.isIncludedSeverance = (sender.isOn) ? true: false
        loadCalculation()
    }
    
    // 환경설정에서 설정한 기본입력값을 셋팅
    func setDefaultInputValues(){
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
    
    //
    func initDisplayValues(){
        lbl_ResultDetail_NP.text = "0 원"
        lbl_ResultDetail_HC.text = "0 원"
        lbl_ResultDetail_LTC.text = "0 원"
        lbl_ResultDetail_EC.text = "0 원"
        lbl_ResultDetail_IncomeTax.text = "0 원"
        lbl_ResultDetail_LocalTax.text = "0 원"
    }
    
    // 계산 메서드. 이 메서드로 호출해주자.
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
    
    // 계산 메서드.
    // 가급적 바로 호출하지 마시고, loadCalculation 메서드로 호출해주세요.
    // 테스트 할 시에만 직접 호출 하세요.
    func calculate(_ _options : SalaryCalculatorOptions) {
        //print(_options.toString())
        
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
        lbl_Result_NetSalary.text = formatCurrency(calculator.netSalary) + " 원"
        
        
        var insurance = Insurance()
        insurance = calculator.getInsurance()
        
        var incomeTax = IncomeTax()
        incomeTax = calculator.getIncomeTax()
        
        //resultDetail.text = String(format:"국민연금 : %@ 원 \r\n건강보험 : %@ 원 \r\n요양보험 : %@ 원 \r\n고용보험 : %@ 원 \r\n소득세 : %@ 원 \r\n지방세 : %@ 원",formatCurrency(insurance.nationalPension),formatCurrency(insurance.healthCare),formatCurrency(insurance.longTermCare),formatCurrency(insurance.employmentCare),formatCurrency(incomeTax.incomeTax),formatCurrency(incomeTax.localTax))
        
        lbl_ResultDetail_NP.text = formatCurrency(insurance.nationalPension) + " 원"
        lbl_ResultDetail_HC.text = formatCurrency(insurance.healthCare) + " 원"
        lbl_ResultDetail_LTC.text = formatCurrency(insurance.longTermCare) + " 원"
        lbl_ResultDetail_EC.text = formatCurrency(insurance.employmentCare) + " 원"
        lbl_ResultDetail_IncomeTax.text = formatCurrency(incomeTax.incomeTax) + " 원"
        lbl_ResultDetail_LocalTax.text = formatCurrency(incomeTax.localTax) + " 원"
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
    func addDoneButtonOnKeyboard()
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
    @objc func keyboard_doneClicked()
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
    
    // Admob 전면광고 생성 메서드
    func createAndLoadInterstitial() -> GADInterstitial?{
        if(!isEnabled_InterstitialAD) { return nil }
        
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
        if(!isEnabled_InterstitialAD) { return }
        
        // 준비가 완료되었다면 화면에 활성 present
        if interstitialAD.isReady {
            interstitialAD.present(fromRootViewController: self)
        } else {
            //print("Ad wasn't ready")
        }
    }
    
    //로드가 완료되었을때 의 처리. 
    // 화면에 보여주기
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if(!isEnabled_InterstitialAD) { return }
        
        //print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    //실패했을때의 처리
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        if(!isEnabled_InterstitialAD) { return }
        
        //print("Fail to receive interstitial")
    }
    
    func initAdmobBanner(){
        if(!isEnabled_BannerAD) { return }
        
        // 애드몹을 사용하려면, 콘텐츠 스크롤 하단부에 여백을 추가로 넣어줌
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        var testDevices : [Any] = []
        testDevices += [kGADSimulatorID] // all simulators
        //testDevices += ["170edde56facd2e95aff519f068efaf0"] // SHiPhone7
        
        let request = GADRequest()
        request.testDevices = testDevices
        
        bannerViewAD = GADBannerView(adSize: kGADAdSizeFullBanner)
        bannerViewAD.adUnitID = "ca-app-pub-6702794513299112/8753530183"
        bannerViewAD.rootViewController = self
        bannerViewAD.delegate = self
        bannerViewAD.load(request)
        self.view.addSubview(bannerViewAD)
        
    }
    func showBanner(){
        if(!isEnabled_BannerAD) { return }
        
        let banner = bannerViewAD!
        
        UIView.beginAnimations("showBanner", context: nil)
        //let rect = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        let rect = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.bounds.height - banner.frame.size.height - CGFloat((self.tabBarController?.tabBar.frame.height)!), width: banner.frame.size.width, height: banner.frame.size.height)
        
        banner.frame = rect
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    func hideBanner(){
        if(!isEnabled_BannerAD) { return }
        
        let banner = bannerViewAD!
        
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // [Admob Banner Type] 로딩이 되면 화면에 보여줌
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if(!isEnabled_BannerAD) { return }
        
        //print("adViewDidReceiveAD")
        showBanner()
    }
    
    // [Admob Banner Type] 에러 발생시에 hide 시킴
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        if(!isEnabled_BannerAD) { return }
        
        //print("adViewDidReceiveAD failed!")
        hideBanner()
    }

    @objc func rotated(){
        hideBanner()
        showBanner()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("count textfield")
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
    func UIColorFromRGBA(R red:CGFloat, G green:CGFloat, B blue:CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

