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
    @IBOutlet weak var iSegmentedAnnual: UISegmentedControl!

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
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        //textfield 가 필요하면 여기에 추가
        inMoney.inputAccessoryView = toolBar
        inTaxFree.inputAccessoryView = toolBar
    }
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        guard let incomeMoney = Double((inMoney?.text!)!) else {
            return
        }
        guard let incomeTaxFree = Double((inTaxFree?.text!)!) else {
            return
        }
        
        let isAnnualIncome = (iSegmentedAnnual.selectedSegmentIndex == 0) ? true : false
        
        
        let calculator = SalaryCalculator()
        calculator.prepare(incomeMoney)
        calculator.Options().child = 0
        calculator.Options().family = 1
        calculator.Options().taxFree = incomeTaxFree
        calculator.Options().isAnnualIncome = isAnnualIncome
        calculator.calculate()
        //resultSummary.text = String(format:"%f",formatter.string(from:calculator.netSalary))
        resultSummary.text = formatCurrency(calculator.netSalary)
        //resultSummary.text = "adasdf"
        
        var insurance = Insurance()
        insurance = calculator.getInsurance()
        
        var incomeTax = IncomeTax()
        incomeTax = calculator.getIncomeTax()
        
        resultDetail.text = String(format:"국민연금 : %@ 원 \r\n건강보험 : %@ 원 \r\n요양보험 : %@ 원 \r\n고용보험 : %@ 원 \r\n소득세 : %@ 원 \r\n지방세 : %@ 원",formatCurrency(insurance.nationalPension),formatCurrency(insurance.healthCare),formatCurrency(insurance.longTermCare),formatCurrency(insurance.employmentCare),formatCurrency(incomeTax.incomeTax),formatCurrency(incomeTax.localTax))

    }
    func formatCurrency(_ value: Double)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
}

