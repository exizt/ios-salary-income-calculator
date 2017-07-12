//
//  CustomBaseLabel.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 10..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class CustomBaseLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func prepareForInterfaceBuilder() {
        customize()
    }
    private func customize(){
        //textColor = UIColorFromRGBA(R: 255, G: 255, B: 255, alpha: 1.0)
    }
    
    func UIColorFromRGBA(R red:CGFloat, G green:CGFloat, B blue:CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
