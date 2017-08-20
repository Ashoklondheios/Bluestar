//
//  SearchLeadTableViewCell.swift
//  Bluestar
//
//  Created by Ashok Londhe on 12/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class SearchLeadTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameTextField: BSTextField!
    
    @IBOutlet weak var productName: BSTextField!
    
    @IBOutlet weak var pincodeTextField: BSTextField!
    
    @IBOutlet weak var statusTextField: BSTextField!
    @IBOutlet weak var mobileTextField: BSTextField!
    @IBOutlet weak var leadIdTextField: BSTextField!
    
    @IBOutlet weak var searchButtion: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productName.rightImageName = "downArrow"
        self.productName.setStyle(.Picker)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
