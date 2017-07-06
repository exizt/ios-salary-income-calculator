//
//  SettingsTableViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 28..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var lbl_InputDefault_Family : UILabel!
    @IBOutlet weak var lbl_InputDefault_Child : UILabel!
    @IBOutlet weak var lbl_InputDefault_Taxfree : UILabel!
    @IBOutlet weak var lbl_InputDefault_IncludedSev : UILabel!
    @IBOutlet weak var lbl_Rate_NationalPension : UILabel!
    @IBOutlet weak var lbl_Rate_HealthCare : UILabel!
    @IBOutlet weak var lbl_Rate_LongTerm : UILabel!
    @IBOutlet weak var lbl_Rate_Employment : UILabel!
    @IBOutlet weak var tableview_Master: UITableView!
    @IBOutlet weak var in_switch_enableCustomRate: UISwitch!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("[SH Debugger] SettingsTableViewController viewWillAppear")
        
        //print("[SH Debugger] Setti...oller viewWillAppear Family "+MyAppSettings.InputDefaults.family.value())
        
        presentSettingData()
        //print(MyAppSettings.Rates.employmentCare.value())
    }
    
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
        //print("[SH Debugger] SettingsTableViewController viewDidAppear")

    }
    
    // didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnResetInputDefault_Touched(_ sender: UIButton) {
        initInputDefaultValues()
        presentSettingData()
    }
    
    @IBAction func btnResetRates_Touched(_ sender: UIButton) {
        initRates()
        presentSettingData()
    }
    
    @IBAction func switchEnableRate_valueChanged(_ sender: UISwitch) {
        if(sender.isOn){
            // 고급 설정 사용 일 때
            SHNUserSettings.Advanced.isEnableCustomRate.set(true)
        } else {
            // 고급 설정 사용 안함 일 때
            SHNUserSettings.Advanced.isEnableCustomRate.set(false)
        }
    }
    // 설정 값을 화면에 표현
    func presentSettingData(){
        // 입력 기본값 설정
        lbl_InputDefault_Family.text = SHNUserSettings.InputDefaults.family.value() + " 명"
        lbl_InputDefault_Child.text = SHNUserSettings.InputDefaults.child.value() + " 명"
        lbl_InputDefault_Taxfree.text = SHNUserSettings.InputDefaults.taxfree.value() + " 원"
        //lbl_InputDefault_IncludedSev.text = MyAppSettings.InputDefaults.includedSev.value()
        
        lbl_InputDefault_IncludedSev.text = (Bool((SHNUserSettings.InputDefaults.includedSev.value() as NSString).boolValue)) ? "포함" : "포함 안함"
        
        // 세율 설정
        lbl_Rate_NationalPension.text = SHNUserSettings.Rates.nationalPension.value() + " %"
        lbl_Rate_HealthCare.text =  SHNUserSettings.Rates.healthCare.value() + " %"
        lbl_Rate_LongTerm.text = SHNUserSettings.Rates.longTermCare.value() + " %"
        lbl_Rate_Employment.text = SHNUserSettings.Rates.employmentCare.value() + " %"
        
        in_switch_enableCustomRate.setOn(SHNUserSettings.Advanced.isEnableCustomRate.bool(), animated: true)
    }
    
    func initRates()
    {
        /**
         * 순서대로
         * 1) 국민연금 요율
         * 2)건강보험 요율
         * 3)요양보험 요율
         * 4)고용보험 요율
         */
        SHNUserSettings.Rates.nationalPension.set(4.5)
        SHNUserSettings.Rates.healthCare.set(3.06)
        SHNUserSettings.Rates.longTermCare.set(6.55)
        SHNUserSettings.Rates.employmentCare.set(0.65)
    }
    
    func initInputDefaultValues()
    {
        SHNUserSettings.InputDefaults.family.set(1)
        SHNUserSettings.InputDefaults.child.set(0)
        SHNUserSettings.InputDefaults.taxfree.set(100000 as Double)
        SHNUserSettings.InputDefaults.includedSev.set(false)
    }
    
    // 초기화 버튼 눌렀을 때 동작할 내용.
    func initDefault_Rates(){
        initRates()
        
        // 화면 갱신
        presentSettingData()
    }
    
    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        //let indexPath = self.tableview_Master.indexPath(for: cell)
        
        var receive_id = SHNUserSettings.Item.family
        enum Class_Type {
            case DetailTableView
            case Rate
        }
        let classType : Class_Type?
        
        switch String(segue.identifier ?? "")! {
        case "segue_family":
            receive_id = SHNUserSettings.Item.family
            classType = Class_Type.DetailTableView
        case "segue_child":
            receive_id = SHNUserSettings.Item.child
            classType = Class_Type.DetailTableView
        case "segue_taxfree":
            receive_id = SHNUserSettings.Item.taxfree
            classType = Class_Type.DetailTableView
        case "segue_includedsev":
            receive_id = SHNUserSettings.Item.includedsev
            classType = Class_Type.DetailTableView
        case "segue_rate_np":
            receive_id = SHNUserSettings.Item.rate_np
            classType = Class_Type.Rate
        case "segue_rate_hc":
            receive_id = SHNUserSettings.Item.rate_hc
            classType = Class_Type.Rate
        case "segue_rate_ltc":
            receive_id = SHNUserSettings.Item.rate_ltc
            classType = Class_Type.Rate
        case "segue_rate_ec":
            receive_id = SHNUserSettings.Item.rate_ec
            classType = Class_Type.Rate
        default:
            receive_id = SHNUserSettings.Item.family
            classType = Class_Type.DetailTableView
        }
        
        if(classType==Class_Type.DetailTableView){
            
            let view = segue.destination as! SettingDetails_TableViewController
            view.title = ((cell.textLabel)?.text)!
            view.receiveItem(receive_id)
            
        } else if(classType==Class_Type.Rate){
            
            let view = segue.destination as! SettingRates_ViewController
            view.title = ((cell.textLabel)?.text)!
            view.receiveItem(receive_id)
        }

    }
}
