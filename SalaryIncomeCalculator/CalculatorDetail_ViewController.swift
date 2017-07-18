//
//  CalculatorDetailViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 16..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

enum CalculatorDetail_ViewController_Receive: Int {
    case np
    case hc
    case ltc
    case ec
    case incomeTax
    case localTax
}

class CalculatorDetail_ViewController: UIViewController {
    var item : CalculatorDetail_ViewController_Receive?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let filepath = Bundle.main.path(forResource: "dictionary", ofType: "xml"){
            do{
                //let contents = try String(contentsOfFile: filepath)
                //let xml = FileManager.default.contents(atPath: filepath)
                
                let xmlData = try NSData(contentsOfFile: filepath)
                
                //print(contents)
                
                /*
                let lines = contents.components(separatedBy: "\n")
                for line in lines {
                    let
                }
                */
            } catch {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func receiveItem(_ item: CalculatorDetail_ViewController_Receive){
        self.item = item
    }
}
