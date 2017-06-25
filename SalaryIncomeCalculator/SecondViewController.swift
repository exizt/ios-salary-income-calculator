//
//  SecondViewController.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 6. 22..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var labelDescription: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelDescription.text = " 이 앱은 연봉, 월급 지급액을 기준으로 월 실수령액 을 계산하는 앱입니다. \r\n 가족수, 자녀수 등의 옵션은 다음 업데이트에서 적용될 예정입니다. \r\n\r\n\r\n사용법\r\n금액을 입력하시고 옵션을 맞게 선택하시면 됩니다.\r\n\r\n오차가 왜 생기나요?\r\n이번 버전은 2017년 2월 기준으로 작성되었습니다. 이후 세율 변경, 근로소득세 계산법 변경 이 발생하면 오차가 발생할 수 있습니다. 오차가 발견될 때마다 업데이트는 계속되어집니다. "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

