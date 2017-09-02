//
//  LeadHistoryTableViewCell.swift
//  Bluestar
//
//  Created by Ashok Londhe on 15/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class LeadHistoryTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var customerNameLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var createOnLabel: UILabel!
    
    @IBOutlet weak var demoFollowDateLabel: UILabel!
    
    @IBOutlet weak var followupLabel: UILabel!

    var lead = NSMutableDictionary() {
        didSet{
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor.gray.cgColor
        self.containerView.layer.borderWidth = 1.0
        self.containerView.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(){
        
        if let customerName = self.lead.value(forKey: "CreatedBy") as? String {
            self.customerNameLabel.text = "Created By:- \(customerName)"
        }
        
        if let comments = self.lead.value(forKey: "Comments") as? String {
            self.commentsLabel.text = "Comments:- \(comments)"
        }
        
        if let createdOn = self.lead.value(forKey: "CreatedOn") as? String {
            self.createOnLabel.text = "Created On:- \(createdOn)"
        }

        if let followUp = self.lead.value(forKey: "FollowUpDate") as? String {
            self.demoFollowDateLabel.text = "Follow Up Date:- \(followUp)"
        }

        if let leadStatus = self.lead.value(forKey: "LeadStatus") as? String {
            self.followupLabel.text = leadStatus
        }

        
    }
    
}
