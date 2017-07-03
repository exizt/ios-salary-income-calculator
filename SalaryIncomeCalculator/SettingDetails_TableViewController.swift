//
//  SettingDetails_TableViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 2..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class SettingDetails_TableViewController: UITableViewController {
    var receiveItem = ""
    var userDefaultOption = MyAppSettings.InputDefaults.family
    var itemLabel: String = ""
    var itemHelpList: [(String,String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = itemLabel
        
        //print("[SH Debugging] SettingDetails_TableViewController viewDidLoad")
        
        //segue_family
        //segue_child
        //segue_taxfree
        //segue_includedsev
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
        //print(msg)
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
            //cell.textField.text = itemValue
            cell.textField.text = userDefaultOption.getValue()
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
    
    func setDetailTitle(_ label: String){
        itemLabel = label
    }
    
    func receiveItem(_ item: String){
        receiveItem = item
        receiveProcess()
    }
    
    func receiveProcess()
    {
        switch receiveItem {
        case "family":
            userDefaultOption = MyAppSettings.InputDefaults.family
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
        case "child":
            userDefaultOption = MyAppSettings.InputDefaults.child
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
        case "taxfree":
            userDefaultOption = MyAppSettings.InputDefaults.taxfree
            break
        case "includedsev":
            userDefaultOption = MyAppSettings.InputDefaults.includedSev
            break
            
        default: break
            
        }
    }
    
    // 목록 에서 선택 하는 메서드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 1){
            let selectedRow = (indexPath as NSIndexPath).row
            let itemValue = itemHelpList[selectedRow]
            
            
            if let textCell = tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) {
                (textCell as! TextFieldCell).textField.text = itemValue.1
                
                // 실제 설정 값을 변경
                //userDefaultOption.set(itemValue.0)
                UserDefaults.standard.set(itemValue.0, forKey: userDefaultOption.getKey())
                //userDefaultOption?.set(itemValue.0)
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //print("[SH Debugger] SettingDetails_TableViewController viewDidDisappear")
        
        let value = UserDefaults.standard.string(forKey: MyAppSettings.InputDefaults.family.getKey())
        print("[SH Debugger] SettingDetails_TableViewController viewDidDisappear : Value "+value!)
        
    }
    
    // 변수를 유효범위 안에 담으려는 메서드
    func validSettingValue(_ _value:String)->String{
        return _value
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
