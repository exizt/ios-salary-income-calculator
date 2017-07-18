//
//  CalculatorDetailViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 16..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit
import AEXML

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
    
    @IBOutlet weak var lbl_test: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let
            xmlPath = Bundle.main.path(forResource: "dictionary", ofType: "xml"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
            else { return }
        do {
            let xmlDoc = try AEXMLDocument(xml: data)
            
            // prints the same XML structure as original
            //print(xmlDoc.xml)
            
            // prints Optional("Tinna") (first element)
            //print(xmlDoc.root["cats"]["cat"].value)
            //print(xmlDoc.root["insurance-nationalpension"].xml)
            print(xmlDoc.root["insurance-nationalpension"]["explanation"].string)
            lbl_test.text = xmlDoc.root["insurance-nationalpension"]["explanation"].string
        }
        catch {
            print("\(error)")
        }
        
        /*
        if let filepath = Bundle.main.path(forResource: "dictionary", ofType: "xml"){
            do{
                //let contents = try String(contentsOfFile: filepath)
                //let xml = FileManager.default.contents(atPath: filepath)
                
                let xmlData = try NSData(contentsOfFile: filepath)
                let xmlDoc = try AEXMLDocument(xml: xmlData)
                
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
         */
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
