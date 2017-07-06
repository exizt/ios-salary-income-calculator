//
//  SettingDetails_TableViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 2..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class SettingDetails_TableViewController: UITableViewController {
    enum ItemDataType {
        case String
        case Int
        case Double
        case Bool
    }

    // 현재 설정되어져 있는 값
    var itemValue: String = ""
    var itemValueLabel: String = ""
    
    // 설정값 구분
    var receiveItem = SHNUserSettings.Item.family
    
    // 설정 값과 연관된 struct enum (변경되어 사용되어질 값)
    var userDefaultOption: SHNUserSettings.InputDefaults = SHNUserSettings.InputDefaults.family
    var itemDataType = ItemDataType.String
    
    // 빠른 선택 목록
    var itemHelpList: [(String,String)] = []
    
    // 직접 입력을 사용할지 유무
    var isEnableEdit = false
    
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
        if(isEnableEdit){
            return 3
        } else {
            return 2
        }
    }

    // Row 개수. by Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isEnableEdit){
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return itemHelpList.count
            default:
                return 1
            }
            
        } else {
            switch section {
            case 0:
                return 1
            case 1:
                return itemHelpList.count
            default:
                return 1
            }
        }
    }

    // Cell 추가. cell 의 형태는 storyboard 에서 prototype 으로 미리 작성해둘 수 있다.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if(isEnableEdit){
            if(indexPath.section == 0){
                return tableViewCell_displayValue(tableView, cellForRowAt: indexPath)
            } else if(indexPath.section == 1){
                return tableViewCell_editValue(tableView, cellForRowAt: indexPath)
            } else {
                return tableViewCell_choiceValue(tableView, cellForRowAt: indexPath)
            }
        } else {
            if(indexPath.section == 0){
                return tableViewCell_displayValue(tableView, cellForRowAt: indexPath)
            } else {
                return tableViewCell_choiceValue(tableView, cellForRowAt: indexPath)
            }
        }
    }

    // 입력값 보여주는 셀
    func tableViewCell_displayValue(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "settingdetail_view_value"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = itemValueLabel

        return cell
    }
    
    // 직접 입력 셀
    func tableViewCell_editValue(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "settingdetail_edit_value"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TextFieldCell
        cell.textField.text = itemValue

        return cell
    }
    
    // 선택 입력 셀
    func tableViewCell_choiceValue(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "settingdetail_choice_value"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as UITableViewCell
        if((indexPath as NSIndexPath).row <= itemHelpList.count){
            cell.textLabel?.text = itemHelpList[(indexPath as NSIndexPath).row].1
        }
        return cell
    }
    
    // Section Group Title 지정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(isEnableEdit){
            switch section {
            case 0:
                return "설정값"
            case 1:
                return "직접 입력"
            case 2:
                return "선택 입력"
            default:
                return "입력"
            }

        } else {
            
            switch section {
            case 0:
                return "설정값"
            case 1:
                return "선택 입력"
            default:
                return "입력"
            }
        }
    }
    
    // 목록 에서 선택 하는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isEnableEdit){
            
            if(indexPath.section == 2){
                tableView_selectRow_itemList(tableView, didSelectRowAt: indexPath)
            }

        } else {
            
            if(indexPath.section == 1){
                tableView_selectRow_itemList(tableView, didSelectRowAt: indexPath)
            }
        }
    }
    
    // 셀 선택시 이벤트
    func tableView_selectRow_itemList(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedRow = (indexPath as NSIndexPath).row
        let itemValue = itemHelpList[selectedRow]
        
        // 실제 설정 값을 변경
        updateOptionValue(itemValue.0,label:itemValue.1)
        
        changeItemValue()
    }
    
    func changeItemValue(){
        // 설정값 보여주는 부분 먼저 변경
        if let labelCell = tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath){
            (labelCell as UITableViewCell).textLabel?.text = itemValueLabel
            
        }
        
        // 직접 입력 부분을 수정
        if(isEnableEdit){
            if let textCell = tableView.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) {
                (textCell as! TextFieldCell).textField.text = itemValue
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
    
    func receiveItem(_ item: SHNUserSettings.Item){
        receiveItem = item
        receiveProcess()
    }
    
    func receiveProcess()
    {
        switch receiveItem {
        case SHNUserSettings.Item.family:
            userDefaultOption = SHNUserSettings.InputDefaults.family
            itemDataType = ItemDataType.Int
            itemValue = userDefaultOption.getValue()
            itemValueLabel = itemValue + " 명"
            itemHelpList = [
                ("1","1 명 (기본)"),
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
        case SHNUserSettings.Item.child:
            userDefaultOption = SHNUserSettings.InputDefaults.child
            itemDataType = ItemDataType.Int
            itemValue = userDefaultOption.getValue()
            itemValueLabel = itemValue + " 명"
            itemHelpList = [
                ("0","0 명 (기본)"),
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
        case SHNUserSettings.Item.taxfree:
            userDefaultOption = SHNUserSettings.InputDefaults.taxfree
            itemDataType = ItemDataType.Double
            itemValue = userDefaultOption.getValue()
            itemValueLabel = itemValue + " 원"
            isEnableEdit = true
            itemHelpList = [
                ("0","0 원"),
                ("10000","10,000 원"),
                ("50000","50,000 원"),
                ("100000","100,000 원 (기본)"),
                ("150000","150,000 원"),
                ("200000","200,000 원")
            ]
            break
        case SHNUserSettings.Item.includedsev:
            userDefaultOption = SHNUserSettings.InputDefaults.includedSev
            itemDataType = ItemDataType.Bool
            itemValue = userDefaultOption.getValue()
            itemValueLabel = (userDefaultOption.bool()) ? "포함" : "포함 안함 (기본)"
            itemHelpList = [
                ("false","포함 안함 (기본)"),
                ("true","포함")
            ]
            break
        default:
            break
        }
    }

    // 변경된 값을 적용
    // itemValue 에 적용. 
    // userDefaultsOption 에 적용
    func updateOptionValue(_ _value:String, label _label:String){
        itemValue = _value
        itemValueLabel = _label
        
        //UserDefaults.standard.set(value, forKey: userDefaultOption.getKey())
        if(itemDataType == ItemDataType.Int){
            let num1: Int = Int((_value as NSString).intValue)
            userDefaultOption.set(num1)
        } else if (itemDataType == ItemDataType.Double){
            let num1: Double = (_value as NSString).doubleValue
            userDefaultOption.set(num1)
        } else if (itemDataType == ItemDataType.Bool){
            if _value == "true" || _value == "false" {
                let val:Bool = (_value == "true") ? true: false
                userDefaultOption.set(val)
            }
        } else {
            userDefaultOption.set(_value)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //print("[SH Debugger] SettingDetails_TableViewController viewDidDisappear")
    }
}
