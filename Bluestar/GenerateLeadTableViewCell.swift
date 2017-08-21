//
//  GenerateLeadTableViewCell.swift
//  Bluestar
//
//  Created by Ashok Londhe on 06/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class GenerateLeadTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameTextField: BSTextField!
    @IBOutlet weak var customerMobileNoTextField: BSTextField!
    
    @IBOutlet weak var alternameMobileNoTextField: BSTextField!
    
    
    @IBOutlet weak var phoneNumberTextField: BSTextField!
    @IBOutlet weak var addressTextField: BSTextField!
    
    @IBOutlet weak var cityTextField: BSTextField!
    @IBOutlet weak var stateTextField: BSTextField!
    @IBOutlet weak var regionTextField: BSTextField!
    @IBOutlet weak var pinCodeTextField: BSTextField!
    @IBOutlet weak var emailIdTextField: BSTextField!
    @IBOutlet weak var enquiryTextField: BSTextField!
    @IBOutlet weak var swcNameTextField: BSTextField!
    @IBOutlet weak var productNameTextField: BSTextField!
    @IBOutlet weak var productModelTextField: BSTextField!
    @IBOutlet weak var statusTextField: BSTextField!
    @IBOutlet weak var demoDateTextFiled: BSTextField!
    @IBOutlet weak var followupDateTextField: BSTextField!
    @IBOutlet weak var commentTextField: BSTextField!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var leadNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTextField()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpTextField() {
        self.customerNameTextField.setStyle(.UserName)
        customerNameTextField.returnKeyType = .next
        
        self.customerMobileNoTextField.setStyle(.PhoneNumber)
        customerNameTextField.returnKeyType = .next

        alternameMobileNoTextField.setStyle(.PhoneNumber)
        customerNameTextField.returnKeyType = .next

        phoneNumberTextField.setStyle(.PhoneNumber)
        customerNameTextField.returnKeyType = .next

        addressTextField.setStyle(.Default)
        addressTextField.returnKeyType = .next

        cityTextField.rightImageName = "downArrow"
        self.cityTextField.setStyle(.Picker)
        customerNameTextField.returnKeyType = .next

        self.stateTextField.setStyle(.Default)
        customerNameTextField.returnKeyType = .next

        self.regionTextField.setStyle(.Default)
        customerNameTextField.returnKeyType = .next

        self.pinCodeTextField.setStyle(.PhoneNumber)
        customerNameTextField.returnKeyType = .next


        self.emailIdTextField.setStyle(.Email)
        customerNameTextField.returnKeyType = .next
        
        enquiryTextField.rightImageName = "downArrow"
        self.enquiryTextField.setStyle(.Picker)
        customerNameTextField.returnKeyType = .next

        self.swcNameTextField.setStyle(.Default)
        customerNameTextField.returnKeyType = .next

        productNameTextField.rightImageName = "downArrow"
        self.productNameTextField.setStyle(.Picker)
        customerNameTextField.returnKeyType = .next

        productModelTextField.rightImageName = "downArrow"
        self.productModelTextField.setStyle(.Picker)
        customerNameTextField.returnKeyType = .next

        statusTextField.rightImageName = "downArrow"
        self.statusTextField.setStyle(.Picker)
        customerNameTextField.returnKeyType = .next

        demoDateTextFiled.rightImageName = "downArrow"
        self.demoDateTextFiled.setStyle(.DatePicker)
        customerNameTextField.returnKeyType = .next

        followupDateTextField.rightImageName = "downArrow"
        self.followupDateTextField.setStyle(.DatePicker)
        customerNameTextField.returnKeyType = .next

        self.commentTextField.setStyle(.Default)
        customerNameTextField.returnKeyType = .next
        self.layoutIfNeeded()
    }
    @IBAction func clearAction(_ sender: UIButton) {
        
    }

    @IBAction func saveLeadAction(_ sender: UIButton) {
        
    }
}
