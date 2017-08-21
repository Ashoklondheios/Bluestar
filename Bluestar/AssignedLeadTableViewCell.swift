//
//  AssignedLeadTableViewCell.swift
//  Bluestar
//
//  Created by Ashok Londhe on 09/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class AssignedLeadTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var followUpLabel: UILabel!
    
    @IBOutlet weak var viewLeadButton: UIButton!

    @IBOutlet weak var editLeadButton: UIButton!
    
    var leadDict = NSDictionary()
    
    
    var custName: String! {
        didSet(newValue) {
                customerNameLabel.text = custName
        }
    }
    
    var mobileNumber: String! {
        didSet(newValue) {
                mobileNoLabel.text = mobileNumber
        }
    }

    var productName: String! {
        didSet(newValue) {
            productNameLabel.text = productName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 7.0
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 1.0
        
        self.viewLeadButton.layer.cornerRadius = 5.0
        self.editLeadButton.layer.cornerRadius = 5.0
        
        leadDict = ServerManager.sharedInstance().leadDictionary
 
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func viewLeadAction(_ sender: UIButton) {
        
    }
    
    @IBAction func editLeadAction(_ sender: UIButton) {
    }
    
    
}
