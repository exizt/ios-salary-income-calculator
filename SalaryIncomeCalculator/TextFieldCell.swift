//
//  TextFieldCell.swift
//  SalaryIncomeCalculator
//
//  Created by SH.Hong on 2017. 7. 2..
//  Copyright © 2017년 SH.Hong. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    /// The text input field.
    @IBOutlet weak var textField: UITextField!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: Properties
    
    
    /// The block to call when the value of the text field changes.
    var valueChanged: ((Void) -> Void)?
    
    // MARK: UITextFieldDelegate
    
    /// Handle the event of the user finishing changing the value of the text field.
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        valueChanged?()
    }
    
    /// Dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
