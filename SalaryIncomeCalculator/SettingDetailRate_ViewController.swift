//
//  SettingRates_ViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 4..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class SettingDetailRate_ViewController: UIViewController {
    enum ReceiveItem: Int{
        case nationalPension
        case healthCare
        case longtermCare
        case employmentCare
    }
    // 값 종류
    var receivedItem: ReceiveItem = .nationalPension
    
    // 설정 값
    var itemValue : Double = 0.0
    
    // 설정 값과 연관된 struct enum
    var userDefaultOption: SHNUserSettings.Rates = SHNUserSettings.Rates.nationalPension
    
    @IBOutlet weak var lbl_depth1: UILabel!
    @IBOutlet weak var lbl_depth2: UILabel!
    @IBOutlet weak var lbl_depth3: UILabel!
    @IBOutlet weak var stepper_depth1: UIStepper!
    @IBOutlet weak var stepper_depth2: UIStepper!
    @IBOutlet weak var stepper_depth3: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeValue(itemValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepperDepth1_valueChanged(_ sender: UIStepper) {
        //lbl_depth1.text = String(format:"%d .",Int(sender.value))
        updateValue()
    }

    @IBAction func stepperDepth2_valueChanged(_ sender: UIStepper) {
        //lbl_depth2.text = String(format:"%d",Int(sender.value))
        updateValue()
    }
    
    @IBAction func stepperDepth3_valueChanged(_ sender: UIStepper) {
        //lbl_depth3.text = String(format:"%d",Int(sender.value))
        updateValue()
    }
    
    
    // stepper 의 값을 가져와서 적용
    func updateValue(){
        itemValue = Double(stepper_depth1.value) + Double(stepper_depth2.value) * 0.1 + Double(stepper_depth3.value) * 0.01
        
        lbl_depth1.text = String(format:"%d .",Int(stepper_depth1.value))
        lbl_depth2.text = String(format:"%d",Int(stepper_depth2.value))
        lbl_depth3.text = String(format:"%d",Int(stepper_depth3.value))
        
        
        //UserDefaults.standard.set(itemValue, forKey: userDefaultOption.getKey())
        userDefaultOption.set(itemValue)
        //print(itemValue)
        
    }
    
    // 값 으로 변경하려고 할 때
    // 개체가 로딩 된 이후에 호출되어야 한다. 그 이전에 호출되면 fatal error
    func changeValue(_ value:Double){
        let separated : [String] = String(value).components(separatedBy: ".")
        guard let major:Double = Double(separated[0]) else {
            return
        }
        stepper_depth1.value = major
        
        let minor = Array(separated[1])
        if minor.count >= 1 {
            if let minor_1 = Double(String(minor[0])) {
                stepper_depth2.value = minor_1
            } else {
                stepper_depth2.value = 0.0
            }
        }
        
        if minor.count >= 2 {
            if let minor_2 = Double(String(minor[1])) {
                stepper_depth3.value = minor_2
            } else {
                stepper_depth3.value = 0.0
            }
        }
        
        updateValue()
    }
    
    func receiveItem(_ receiveItem: ReceiveItem){
        receiveProcess(receiveItem)
    }

    func receiveProcess(_ receiveItem: ReceiveItem)
    {
        self.receivedItem = receiveItem
        
        switch receiveItem {
        case .nationalPension:
            userDefaultOption = SHNUserSettings.Rates.nationalPension
        case .healthCare:
            userDefaultOption = SHNUserSettings.Rates.healthCare
        case .longtermCare:
            userDefaultOption = SHNUserSettings.Rates.longTermCare
        case .employmentCare:
            userDefaultOption = SHNUserSettings.Rates.employmentCare
        }
        itemValue = Double(userDefaultOption.getValue())!
        
    }
}
