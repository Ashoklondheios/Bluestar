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
    
    @IBOutlet weak var modelHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpTextField() {
        
        self.customerNameTextField.setStyle(.UserName)
        
        self.customerMobileNoTextField.setStyle(.PhoneNumber)
        
        alternameMobileNoTextField.setStyle(.PhoneNumber)
        
        phoneNumberTextField.setStyle(.PhoneNumber)
        
        addressTextField.placeholder = "Address"
        addressTextField.setStyle(.Default)
        addressTextField.returnKeyType = .next

        cityTextField.setStyle(.Default)
        
        stateTextField.setStyle(.Default)
        
        regionTextField.setStyle(.Default)
        
        pinCodeTextField.setStyle(.PhoneNumber)

        emailIdTextField.setStyle(.Email)
        
        
        enquiryTextField.rightImageName = "downArrow"
        enquiryTextField.setStyle(.Picker)
        
        swcNameTextField.setStyle(.Default)
        
        productNameTextField.rightImageName = "downArrow"
        productNameTextField.setStyle(.Picker)
        
        productModelTextField.isHidden = true
        self.modelHeightConstraint.constant = 0
        //productModelTextField.rightImageName = "downArrow"
        //self.productModelTextField.setStyle(.Picker)
        
        statusTextField.rightImageName = "downArrow"
        self.statusTextField.setStyle(.Picker)
        
        demoDateTextFiled.rightImageName = "downArrow"
        self.demoDateTextFiled.setStyle(.DatePicker)
        
        followupDateTextField.rightImageName = "downArrow"
        self.followupDateTextField.setStyle(.DatePicker)
    
        self.commentTextField.setStyle(.Default)
        
        self.layoutIfNeeded()
    }
    @IBAction func clearAction(_ sender: UIButton) {
        
    }

    @IBAction func saveLeadAction(_ sender: UIButton) {
        
    }
}
