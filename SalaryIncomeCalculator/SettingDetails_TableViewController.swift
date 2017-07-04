//
//  SettingDetails_TableViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 2..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class SettingDetails_TableViewController: UITableViewController {
    // 설정 값
    var itemValue: String = ""
    // 값 종류
    var receiveItem = MyAppSettings.Item.family
    // 설정 값과 연관된 struct enum
    var userDefaultOption: MyAppSettings.InputDefaults = MyAppSettings.InputDefaults.family
    enum ItemDataType {
        case String
        case Int
        case Double
        case Bool
    }
    var itemDataType = ItemDataType.String
   // 빠른 선택 목록
    var itemHelpList: [(String,String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("[SH Debugging] SettingDetails_TableViewController viewDidLoad")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Section 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    // Row 개수. by Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let msg = String(format: "Section : %d", section)
        switch section {
        case 1:
            return itemHelpList.count
        default:
            return 1
        }
    }

    // Cell 추가. cell 의 형태는 storyboard 에서 prototype 으로 미리 작성해둘 수 있다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String = ""
       
        // Configure the cell...
        if(indexPath.section == 0){
            
            identifier = "settingdetail_edit_value"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TextFieldCell
            cell.textField.text = itemValue
            return cell
        } else {
            
            identifier = "settingdetail_choice_value"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            if((indexPath as NSIndexPath).row <= itemHelpList.count){
                cell.textLabel?.text = itemHelpList[(indexPath as NSIndexPath).row].1
            }
            return cell
        }
    }

    // Section Group Title 지정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "빠른 입력"
        default:
            return "직접 입력"
        }
    }
    
    // 목록 에서 선택 하는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 1){
            let selectedRow = (indexPath as NSIndexPath).row
            let itemValue = itemHelpList[selectedRow]
            
            
            if let textCell = tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) {
                // 라벨을 변경
                (textCell as! TextFieldCell).textField.text = itemValue.1
                
                // 실제 설정 값을 변경
                updateOptionValue(itemValue.0)
            }
        }
    }
    
    // 셀 높이 지정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*
        if(editType == EditType.percentage){
            if indexPath.row == 0 {
                return 88.0
            }
        }
        */
        
        return 44.0
    }
    
    func receiveItem(_ item: MyAppSettings.Item){
        receiveItem = item
        receiveProcess()
    }
    
    func receiveProcess()
    {
        switch receiveItem {
        case MyAppSettings.Item.family:
            userDefaultOption = MyAppSettings.InputDefaults.family
            itemDataType = ItemDataType.Int
            itemHelpList = [
                ("1","1 명"),
                ("2","2 명"),
                ("3","3 명"),
                ("4","4 명"),
                ("5","5 명"),
                ("6","6 명"),
                ("7","7 명"),
                ("8","8 명"),
                ("9","9 명")
            ]
            break
        case MyAppSettings.Item.child:
            userDefaultOption = MyAppSettings.InputDefaults.child
            itemDataType = ItemDataType.Int
            itemHelpList = [
                ("0","0 명"),
                ("1","1 명"),
                ("2","2 명"),
                ("3","3 명"),
                ("4","4 명"),
                ("5","5 명"),
                ("6","6 명"),
                ("7","7 명"),
                ("8","8 명"),
                ("9","9 명")
            ]
            break
        case MyAppSettings.Item.taxfree:
            userDefaultOption = MyAppSettings.InputDefaults.taxfree
            itemDataType = ItemDataType.Double
            itemHelpList = [
                ("0","0 원"),
                ("10000","10,000 원"),
                ("50000","50,000 원"),
                ("100000","100,000 원"),
                ("150000","150,000 원"),
                ("200000","200,000 원")
            ]
            break
        case MyAppSettings.Item.includedsev:
            userDefaultOption = MyAppSettings.InputDefaults.includedSev
            itemHelpList = [
                ("false","포함 안함"),
                ("true","포함")
            ]
            break
        default:
            break
        }
        
        itemValue = userDefaultOption.getValue()
    }

    //
    func updateOptionValue(_ _value:String){
        itemValue = _value
        
        //UserDefaults.standard.set(value, forKey: userDefaultOption.getKey())
        if(itemDataType == ItemDataType.Int){
            let num1: Int = Int((_value as NSString).intValue)
            userDefaultOption.set(num1)
        } else if (itemDataType == ItemDataType.Double){
            let num1: Double = (_value as NSString).doubleValue
            userDefaultOption.set(num1)
        } else {
            userDefaultOption.set(_value)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //print("[SH Debugger] SettingDetails_TableViewController viewDidDisappear")
    }
}
