//
//  SettingsTableViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 28..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class Settings_ViewController: UITableViewController {
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

    // 네비게이션 컨트롤러 를 이용해서 하위 뷰와 연결하는 메서드.
    // 정확히는 segue 를 통하기 직전에 호출되는 메서드.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell

        // segue id 에 따른 분기
        switch String(segue.identifier ?? "")! {
        case "segue_family":
            prepare_detailView(cell, destination: segue.destination, receiveItem: .family)
        case "segue_child":
            prepare_detailView(cell, destination: segue.destination, receiveItem: .child)
        case "segue_taxfree":
            prepare_detailView(cell, destination: segue.destination, receiveItem: .taxfree)
        case "segue_includedsev":
            prepare_detailView(cell, destination: segue.destination, receiveItem: .includedsev)
        case "segue_rate_np":
            prepare_detailRateView(cell, destination: segue.destination, receiveItem: .nationalPension)
        case "segue_rate_hc":
            prepare_detailRateView(cell, destination: segue.destination, receiveItem: .healthCare)
        case "segue_rate_ltc":
            prepare_detailRateView(cell, destination: segue.destination, receiveItem: .longtermCare)
        case "segue_rate_ec":
            prepare_detailRateView(cell, destination: segue.destination, receiveItem: .employmentCare)
        default:
            break
        }
    }
    
    // SettingDetail_ViewController
    func prepare_detailView(_ cell: UITableViewCell, destination: Any, receiveItem: SettingDetails_TableViewController.ReceiveItem){
        let view = destination as! SettingDetails_TableViewController
        view.title = ((cell.textLabel)?.text)!
        view.receiveItem(receiveItem)
    }
    
    // SettingDetailRate_ViewController
    func prepare_detailRateView(_ cell: UITableViewCell, destination: Any, receiveItem: SettingRates_ViewController.ReceiveItem){
        let view = destination as! SettingRates_ViewController
        view.title = ((cell.textLabel)?.text)!
        //view.receiveItem(receiveItem)
    }
}
