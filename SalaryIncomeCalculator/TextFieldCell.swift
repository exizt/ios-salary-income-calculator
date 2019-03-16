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
    var maxLength = 10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.inputAccessoryView = getDoneButtonToolbar()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: Properties
    
    
    /// The block to call when the value of the text field changes.
    var valueChanged: (() -> Void)?
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //print("count textfield")
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        return newLength <= maxLength
    }
    
    /**
     * 키보드 바로 위에 [Done] 추가하는 메서드
     */
    func getDoneButtonToolbar() -> UIToolbar
    {
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        doneToolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        return doneToolbar
    }
    @objc func doneClicked()
    {
        textField.resignFirstResponder()
    }
}
