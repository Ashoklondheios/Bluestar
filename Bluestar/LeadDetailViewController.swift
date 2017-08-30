//
//  LeadDetailViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 14/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class LeadDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    @IBOutlet weak var leadDetailTableView: UITableView!
    var lead = NSMutableDictionary()
    var leads = [NSMutableDictionary]()
    var currentElement = ""
    var custmerName = ""
    var mobileNumber = ""
    var alternateMobileNo = ""
    var emailId = ""
    var address = ""
    var cityName = ""
    var pincode = ""
    var leadSource = ""
    var leadSubSource = ""
    var swcName = ""
    var modelName = ""
    var seriesNumber = ""
    var productName = ""
    var status = ""
    var leadDate = ""
    var demoFixedDate = ""
    var followupDate = ""
    var createdBy = ""
    var leadAssignedTo = ""
    var comments = ""
    var createdOn = ""
    var leadStatus = ""
    var location = ""
    var region = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leadDetailTableView.register(UINib(nibName: "ViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ViewTableViewCell")
        self.title = "BlueStar"
        self.leadDetailTableView.register(UINib(nibName: "LeadHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "leadHistoryTableViewCell")
        addCustomNavigationButton()
        
        
        if let seriesNumber = lead.value(forKey: "SeriesNumber") as? String ,let customerName = lead.value(forKey: "CustomerName") as? String, let productName = lead.value(forKey: "ProductName") as? String, let phoneNumber = lead.value(forKey: "MobileNumber") as? String, let status = lead.value(forKey: "Status") as? String  {
            showProgressLoader()
            ServerManager.sharedInstance().getLeads(leadId: seriesNumber, customerName: customerName, phoneNumber: phoneNumber, pinCode: "", productName: productName, status: status) { (result, data) in
                let parser = XMLParser(data: data)
                parser.delegate = self
                let success:Bool = parser.parse()
                DispatchQueue.main.async {
                    self.hideProgressLoader()
                }

                if success {
                    self.getCityName()
                }
            }
            
        }
        // Do any additional setup after loading the view.
    }
    func getCityName() {
        if (cityName.characters.count) > 2 {
            ServerManager.sharedInstance().getCityDetails(pincode: cityName) { (result, data) in
                let parser = XMLParser(data: data)
                parser.delegate = self
                let success:Bool = parser.parse()
                if success {
                    self.leads[0].setValue(self.region, forKey: "CityRegion")
                    DispatchQueue.main.async {
                        self.leadDetailTableView.delegate = self
                        self.leadDetailTableView.dataSource = self
                        self.leadDetailTableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ViewTableViewCell", for: indexPath) as? ViewTableViewCell
            if cell == nil {
                cell = (tableView.dequeueReusableCell(withIdentifier: "ViewTableViewCell", for: indexPath) as? ViewTableViewCell)!
                
            }
            if let pincode = self.leads[indexPath.row].value(forKey: "Pincode") as? String {
                if pincode.characters.count == 6 {
                    ServerManager.sharedInstance().getPincodeDetails(pincode: pincode, completion: { (result, data) in
                        let parser = XMLParser(data: data)
                        parser.delegate = self
                        let success:Bool = parser.parse()
                        if success {
                            self.leads[0].setValue(self.location, forKey: "Location")
                        }
                        
                    })
                    
                }
            }
            cell?.lead = self.leads[indexPath.row]
            return cell!
        } else {
            var cell = leadDetailTableView.dequeueReusableCell(withIdentifier: "leadHistoryTableViewCell", for: indexPath) as? LeadHistoryTableViewCell
            if cell == nil {
                cell = (leadDetailTableView.dequeueReusableCell(withIdentifier: "leadHistoryTableViewCell", for: indexPath) as? LeadHistoryTableViewCell)!
            }
            cell?.lead = self.leads[indexPath.row];
            return  cell!
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement =  elementName
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Lead" {
            lead = NSMutableDictionary()
            lead.setValue(custmerName, forKey: "CustomerName")
            lead.setValue(leadAssignedTo, forKey: "LeadAssignedTo")
            lead.setValue(mobileNumber, forKey: "MobileNumber")
            lead.setValue(seriesNumber, forKey: "SeriesNumber")
            lead.setValue(productName, forKey: "ProductName")
            lead.setValue(leadDate, forKey: "LeadDate")
            lead.setValue(status, forKey: "Status")
            lead.setValue(address, forKey: "Address")
            lead.setValue(emailId, forKey: "EmailID")
            lead.setValue(alternateMobileNo, forKey: "AlternateMobileNumber")
            lead.setValue(cityName, forKey: "CityName")
            lead.setValue(pincode, forKey: "Pincode")
            lead.setValue(location, forKey: "Location")
            lead.setValue(swcName, forKey: "SwcName")
            lead.setValue(modelName, forKey: "ModelName")
            lead.setValue(demoFixedDate, forKey: "DemoFixedDate")
            lead.setValue(followupDate, forKey: "FollowUpFixedDate")
            lead.setValue(comments, forKey: "Comments")
            
            if !leads.contains(lead) {
                leads.append(lead)
            }
            
        }
        
        if elementName == "LeadUpdate" {
            lead = NSMutableDictionary()
            lead.setValue(createdBy, forKey: "CreatedBy")
            lead.setValue(leadAssignedTo, forKey: "LeadAssignedTo")
            lead.setValue(demoFixedDate, forKey: "DemoFixedDate")
            lead.setValue(followupDate, forKey: "FollowUpDate")
            lead.setValue(createdOn, forKey: "CreatedOn")
            lead.setValue(comments, forKey: "Comments")
            lead.setValue(leadStatus, forKey: "LeadStatus")
            if !leads.contains(lead) {
                leads.append(lead)
            }
        }
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "CustomerName" {
            custmerName = string
        }
        
        if currentElement == "MobileNumber" {
            mobileNumber = string
        }
        if currentElement == "AlternateMobileNumber" {
            alternateMobileNo = string
        }
        
        if currentElement == "SeriesNumber" {
            seriesNumber = string
        }
        
        if currentElement == "ProductName" {
            productName = string
        }
        
        if currentElement == "LeadDate" {
            leadDate = string
        }
        
        if currentElement == "Status" {
            status = string
        }
        if currentElement == "Address" {
            address = string
        }
        
        if currentElement == "EmailID" {
            emailId = string
        }
        
        if currentElement == "CityName" {
            cityName = string
        }
        
        if currentElement == "Pincode" {
            pincode = string
        }
        
        if currentElement == "DemoFixedDate" {
            demoFixedDate = string
        }
        
        if currentElement == "FollowUpFixedDate" {
            followupDate = string
        }
        
        if currentElement == "SwcName" {
            swcName = string
        }
        
        if currentElement == "CreatedBy" {
            createdBy = string
        }
        
        if currentElement == "FollowUpDate" {
            followupDate = string
        }
        
        if currentElement == "CreatedOn" {
            createdOn = string
        }
        
        if currentElement == "LeadAssignedTo" {
            leadAssignedTo = string
        }
        
        if currentElement == "Comments" {
            comments = string
        }
        
        if currentElement == "LeadStatus" {
            leadStatus = string
        }
        
        if currentElement == "ModelName" {
            modelName = string
        }
        if currentElement == "Location" {
            location = string
        }
        
        if currentElement == "CityRegion" {
            region = string
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leadSegue" {
            let vc = segue.destination as? LeadViewController
            vc?.isGenerateLead = false
            vc?.lead = self.leads[0]
        }
    }
    
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "leadSegue", sender: nil)
    }
    
    @IBAction func historyButtonAction(_ sender: UIButton) {
        
        if leads.count > 0 {
        showProgressLoader()
        if let seriesNumber = self.leads[0].value(forKey: "SeriesNumber") as? String {
            ServerManager.sharedInstance().getLeadHistory(seriesNumber: seriesNumber) { (result, data) in
                let parser = XMLParser(data: data)
                parser.delegate = self
                let success:Bool = parser.parse()
                DispatchQueue.main.async {
                    self.hideProgressLoader()
                }
                if success {
                    DispatchQueue.main.async {
                        self.leadDetailTableView.reloadData()
                        if self.leads.count > 1 {
                            self.leadDetailTableView.scrollToRow(at: IndexPath.init(row: self.leads.count-1, section: 0), at: UITableViewScrollPosition.top, animated: false)
                        }
                        
                    }
                }
                
            }
        }
        } else {
            showToast(message: "No history Found.")
        }
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        goToParentViewController()
    }
}
