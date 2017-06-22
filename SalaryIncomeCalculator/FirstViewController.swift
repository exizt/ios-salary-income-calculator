//
//  FirstViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var resultSummary: UILabel!
    @IBOutlet weak var inMoney: UITextField!
    @IBOutlet weak var inTaxFree: UITextField!
    @IBOutlet weak var resultDetail: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewDidLoad_keyboardDone()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewDidLoad_keyboardDone()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: false)
        
        //textfield 가 필요하면 여기에 추가
        inMoney.inputAccessoryView = toolBar
    }
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        
        var calculator = SalaryCalculator()
        calculator.calculate()
        resultSummary.text = String(format:"%f",calculator.getInsurance().nationalPension)
        
        //resultSummary.text = "adasdf"
        
        var insurance = Insurance()
        insurance = calculator.getInsurance()
        
        var incomeTax = IncomeTax()
        incomeTax = calculator.getIncomeTax()
        
        resultDetail.text = String(format:"국민연금 : %f \r\n건강보험 : %f \r\n요양보험 : %f \r\n고용보험 : %f \r\n소득세 : %f \r\n지방세 : %f",insurance.nationalPension,insurance.healthCare,insurance.longTermCare,insurance.employmentCare,incomeTax.incomeTax,incomeTax.localTax)

    }
}

