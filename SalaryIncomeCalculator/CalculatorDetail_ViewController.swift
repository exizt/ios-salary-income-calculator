//
//  CalculatorDetailViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 16..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit
import AEXML


class CalculatorDetail_ViewController: UIViewController {
    enum ReceiveItem : Int {
        case np
        case hc
        case ltc
        case ec
        case incomeTax
        case localTax
    }
    var receivedItem: ReceiveItem = .np
    var str_explanation: NSAttributedString = NSAttributedString()
    var str_rateHistory: NSAttributedString = NSAttributedString()
    let isDebug = false
    
    @IBOutlet weak var txview_description: UITextView!
    @IBOutlet weak var segcontrol_master: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segcontrol_master.addTarget(self, action: #selector(self.segcontrol_master_valueChanged(_:)), for: .valueChanged)
        txview_description.textContainerInset = UIEdgeInsetsMake(0, 20, 0, 20)
        //print("CalculatorDetail viewDidLoad")
        if #available(iOS 11.0, *){
            //self.view
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
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
            //print(xmlDoc.root["insurance-nationalpension"]["explanation"].string)
            
            var key: String = ""
            
            switch receivedItem {
            case .np :
                key = "insurance-nationalpension"
            case .hc :
                key = "insurance-healthcare"
            case .ltc :
                key = "insurance-longtermcare"
            case .ec :
                key = "insurance-employmentcare"
            default:
                key = ""
                break
            }
            
            let explanation = xmlDoc.root[key]["explanation"].string
            let rateHistory = xmlDoc.root[key]["history"].string
                
            do {
                str_explanation = try NSAttributedString(data: explanation.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                    
                str_rateHistory = try NSAttributedString(data: rateHistory.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                    
                txview_description.attributedText = str_explanation
            } catch {
                print(error)
            }
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
    

    @objc func segcontrol_master_valueChanged(_ sender: UISegmentedControl){
        //print("segcontrol_master_valueChanged ")
        //print(sender.selectedSegmentIndex)
        debugPrint("segmentedControl Changed")
        switch sender.selectedSegmentIndex {
        case 0:
            txview_description.attributedText = str_explanation
            break
        case 1:
            txview_description.attributedText = str_rateHistory
            break
        case 2:
            break
        default:
            break
        }
    }

    func receiveItem(_ item: ReceiveItem){
        self.receivedItem = item
    }
    
    
    func debugPrint(_ message:String){
        if(isDebug){
            print("[CalculatorDetails]"+message)
        }
    }
}
