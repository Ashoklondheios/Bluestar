//
//  ViewTableViewCell.swift
//  Bluestar
//
//  Created by Ashok Londhe on 14/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class ViewTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var enquiryNoLabel: UILabel!
    
    @IBOutlet weak var productReferenceLabel: UILabel!
    
    @IBOutlet weak var modelReferenceLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!

    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var alternateMobileNo: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var pincodeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var followupDateLabel: UILabel!
    
    @IBOutlet weak var demoFixedDateLabel: UILabel!
    
    @IBOutlet weak var swcLabel: UILabel!
    
    var lead  = NSMutableDictionary() {
        didSet {
            bindData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
         //       self.customerNameLabel.attributedText = attributedString1
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        self.containerView.layer.borderWidth = 1.0
        self.containerView.clipsToBounds = true
        bindData()
        containerView.layoutIfNeeded()
    }
    func bindData() {
        
        if let customerName = lead.value(forKey: "SeriesNumber") as? String {
            self.enquiryNoLabel.attributedText = getAttributedString(mainString: "Enq. No.:  ", value: customerName)
        } else {
            self.enquiryNoLabel.attributedText = getAttributedString(mainString: "Enq. No.:  ", value: "")
        }
        
        if let customerName = lead.value(forKey: "ProductName") as? String {
            self.productReferenceLabel.attributedText = getAttributedString(mainString: "Product Reference:  ", value: customerName)
        } else {
            self.productReferenceLabel.attributedText = getAttributedString(mainString: "Product Reference:  ", value: "")
        }

        if let customerName = lead.value(forKey: "ModelName") as? String {
            self.modelReferenceLabel.attributedText = getAttributedString(mainString: "Model Reference  ", value: customerName)
        } else {
            self.modelReferenceLabel.attributedText = getAttributedString(mainString: "Model Reference:  ", value: "")
        }

        
        if let customerName = lead.value(forKey: "CustomerName") as? String {
            self.customerNameLabel.attributedText = getAttributedString(mainString: "Customer Name:  ", value: customerName)
        } else {
            self.customerNameLabel.attributedText = getAttributedString(mainString: "Customer Name:  ", value: "")
        }
        
        
        if let mobileNumber = lead.value(forKey: "MobileNumber") as? String {
            self.mobileNumberLabel.attributedText = getAttributedString(mainString: "Mobile No:.  ", value: mobileNumber)
        } else {
            self.mobileNumberLabel.attributedText = getAttributedString(mainString: "Mobile No:.  ", value: "")
        }
        

        if let customerName = lead.value(forKey: "AlternateMobileNumber") as? String {
            self.alternateMobileNo.attributedText = getAttributedString(mainString: "Alt Mobile No.:  ", value: customerName)
        } else {
            self.alternateMobileNo.attributedText = getAttributedString(mainString: "Alt Mobile No.:  ", value: "")
        }
        
        if let phoneNumber = lead.value(forKey: "phoneNumber") as? String {
            self.phoneNumber.attributedText = getAttributedString(mainString: "Phone No.:  ", value: phoneNumber)
        } else {
            self.phoneNumber.attributedText = getAttributedString(mainString: "Phone No.:  ", value: "")
        }


        if let customerName = lead.value(forKey: "EmailID") as? String {
            self.emailIdLabel.attributedText = getAttributedString(mainString: "Email ID:  ", value: customerName)
        } else {
            self.emailIdLabel.attributedText = getAttributedString(mainString: "Email ID:  ", value: "")
        }

        if let customerName = lead.value(forKey: "CityName") as? String {
            self.cityLabel.attributedText = getAttributedString(mainString: "City:  ", value: customerName)
            
        } else {
            self.cityLabel.attributedText = getAttributedString(mainString: "City:  ", value: "")
        }
        
        
        if let country = lead.value(forKey: "Country") as? String {
            self.countryLabel.attributedText = getAttributedString(mainString: "Country:  ", value: country)
        } else {
            self.countryLabel.attributedText = getAttributedString(mainString: "Country:  ", value: "")
        }
        
        if let state = lead.value(forKey: "State") as? String {
            self.stateLabel.attributedText = getAttributedString(mainString: "State:  ", value: state)
        } else {
            self.stateLabel.attributedText = getAttributedString(mainString: "State:  ", value: "")
        }


        
        if let customerName = lead.value(forKey: "Address") as? String {
            self.addressLabel.attributedText = getAttributedString(mainString: "Address:  ", value: customerName)
        } else {
        self.addressLabel.attributedText = getAttributedString(mainString: "Address:  ", value: "")
        }
        
        
        if let customerName = lead.value(forKey: "Pincode") as? String {
            self.pincodeLabel.attributedText = getAttributedString(mainString: "Pincode:  ", value: customerName)
        }else {
            self.pincodeLabel.attributedText = getAttributedString(mainString: "Pincode:  ", value: "")
        }
        
        
        if let customerName = lead.value(forKey: "Status") as? String {
            self.statusLabel.attributedText = getAttributedString(mainString: "Stauts:  ", value: customerName)
        } else {
            self.statusLabel.attributedText = getAttributedString(mainString: "Stauts:  ", value: "")
        
        }
        if let customerName = lead.value(forKey: "SwcName") as? String {
            self.swcLabel.attributedText = getAttributedString(mainString: "SWC Name:  ", value: customerName)
        } else {
            self.swcLabel.attributedText = getAttributedString(mainString: "SWC Name:  ", value: "")
        }

        if let customerName = lead.value(forKey: "DemoFixedDate") as? String {
            self.demoFixedDateLabel.attributedText = getAttributedString(mainString: "Demo Fixed On:  ", value: customerName)
        } else {
            self.demoFixedDateLabel.attributedText = getAttributedString(mainString: "Demo Fixed On:  ", value: "")
        }

        if let customerName = lead.value(forKey: "FollowUpFixedDate") as? String {
            self.followupDateLabel.attributedText = getAttributedString(mainString: "Follow Up Date:  ", value: customerName)
        } else {
            self.followupDateLabel.attributedText = getAttributedString(mainString: "Follow Up Date:  ", value: "")
        }


    }
    
    func getAttributedString(mainString: String , value : String) -> NSAttributedString {
        let attrs1 = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.black]
        let attrs2 = [NSFontAttributeName : UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : UIColor.black]
        let attributedString1 = NSMutableAttributedString(string: mainString, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string: value, attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
