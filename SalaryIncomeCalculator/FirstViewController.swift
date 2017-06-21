//
//  FirstViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var resultSummary: UILabel!
    @IBOutlet weak var inMoney: UITextField!
    @IBOutlet weak var inTaxFree: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calculate(_ sender: UIButton) {
        resultSummary.text = "adasdf"
    }
}

