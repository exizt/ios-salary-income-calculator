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
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //UserDefaults.standard.set(1, forKey: "Name")
        //print("[SH Debugger] SettingsTableViewController viewDidLoad")
        
        initRates()
        initInputDefaultValues()
        
        
    }
    
    // viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("[SH Debugger] SettingsTableViewController viewWillAppear")
        
        //print("[SH Debugger] Setti...oller viewWillAppear Family "+MyAppSettings.InputDefaults.family.value())
        
        presentSettingData()

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

    // 설정 값을 화면에 표현
    func presentSettingData(){
        // 입력 기본값 설정
        lbl_InputDefault_Family.text = MyAppSettings.InputDefaults.family.value() + " 명"
        lbl_InputDefault_Child.text = MyAppSettings.InputDefaults.child.value() + " 명"
        lbl_InputDefault_Taxfree.text = MyAppSettings.InputDefaults.taxfree.value() + " 원"
        lbl_InputDefault_IncludedSev.text = MyAppSettings.InputDefaults.includedSev.value()
        
        // 세율 설정
        lbl_Rate_NationalPension.text = MyAppSettings.Rates.nationalPension.value()
        lbl_Rate_HealthCare.text =  MyAppSettings.Rates.healthCare.value()
        lbl_Rate_LongTerm.text = MyAppSettings.Rates.longTermCare.value()
        lbl_Rate_Employment.text = MyAppSettings.Rates.employmentCare.value()
        
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
        MyAppSettings.Rates.nationalPension.set(4.5)
        MyAppSettings.Rates.healthCare.set(3.06)
        MyAppSettings.Rates.longTermCare.set(6.55)
        MyAppSettings.Rates.employmentCare.set(0.65)
    }
    
    func initInputDefaultValues()
    {
        MyAppSettings.InputDefaults.family.set(1)
        MyAppSettings.InputDefaults.child.set(0)
        MyAppSettings.InputDefaults.taxfree.set(100000)
        MyAppSettings.InputDefaults.includedSev.set(false)
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
        let itemLabel : String = ((cell.textLabel)?.text)!
        //print(itemLabel)
        
        if segue.identifier == "segue_famliy" {
            let detailView = segue.destination as! SettingDetails_TableViewController
            detailView.receiveItem("family")
            detailView.setDetailTitle(itemLabel)
        } else if segue.identifier == "segue_child" {
            let detailView = segue.destination as! SettingDetails_TableViewController
            detailView.receiveItem("child")
            detailView.setDetailTitle(itemLabel)
        } else if segue.identifier == "segue_taxfree" {
            let detailView = segue.destination as! SettingDetails_TableViewController
            detailView.receiveItem("taxfree")
            detailView.setDetailTitle(itemLabel)
        } else if segue.identifier == "segue_includedsev" {
            let detailView = segue.destination as! SettingDetails_TableViewController
            detailView.receiveItem("includedsev")
            detailView.setDetailTitle(itemLabel)
        }
    }
}
