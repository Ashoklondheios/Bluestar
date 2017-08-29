//
//  AssignedLeadViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 09/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class AssignedLeadViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

    @IBOutlet weak var assignedLeadTableView: UITableView!
    var currentElement = ""
    let count = 0
    var lead = NSMutableDictionary()
    var custmerName = ""
    var mobileNumber = ""
    var address = ""
    var seriesNumber = ""
    var productName = ""
    var status = ""
    var leadDate = ""
    var leads = [NSMutableDictionary]()
    var isGenerateLead = true
    var selectedLead = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignedLeadTableView.register(UINib(nibName: "AssignedLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "assignedLeadCell")
        self.assignedLeadTableView.delegate = self
        self.assignedLeadTableView.dataSource = self
        self.title = "Assigned Leads"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         custmerName = ""
         mobileNumber = ""
         address = ""
         seriesNumber = ""
         productName = ""
         status = ""
         leadDate = ""
        //self.navigationItem.hidesBackButton = true()
        addCustomNavigationButton()
        if let userId = ServerManager.sharedInstance().userDetailsDict.value(forKey: "ID") as? String {
            showProgressLoader()
            ServerManager.sharedInstance().getAssigned(userID: userId){ (result, data) in
                let parser = XMLParser(data: data)
                parser.delegate = self
                let success:Bool = parser.parse()
                DispatchQueue.main.async {
                    self.hideProgressLoader()
                }

                if success {
                    print("lead count \(self.leads.count)")
                    DispatchQueue.main.async {
                        self.assignedLeadTableView.reloadData()
                        if self.leads.count == 0 {
                            self.showToast(message: "No assigend leads for Today")
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = assignedLeadTableView.dequeueReusableCell(withIdentifier: "assignedLeadCell", for: indexPath) as? AssignedLeadTableViewCell
        if cell == nil {
            cell = (assignedLeadTableView.dequeueReusableCell(withIdentifier: "assignedLeadCell", for: indexPath) as? AssignedLeadTableViewCell)!
        
        }
        cell?.editLeadButton.addTarget(self, action: #selector(self.editLead(button:)), for: .touchUpInside)
        cell?.viewLeadButton.addTarget(self, action: #selector(self.viewLead(button:)), for: .touchUpInside)
        cell?.viewLeadButton.tag = indexPath.row
        cell?.editLeadButton.tag = indexPath.row
        // cell?.editLeadButton.
        if let customerName = self.leads[indexPath.row].value(forKey: "CustomerName") as? String {
            cell?.custName = customerName
        }
        
        if let mobileNo = self.leads[indexPath.row].value(forKey: "MobileNumber") as? String {
            cell?.mobileNumber = mobileNo
        }
        
        if let productName = self.leads[indexPath.row].value(forKey: "ProductName") as? String {
            cell?.productName = productName
        }
        
        
        cell?.selectionStyle = .none
        return  cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
     func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : AnyObject] = [:]) {
        if elementName == "Leads" {
        }
        currentElement =  elementName
    }
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Lead" {
            lead = NSMutableDictionary()
            lead.setValue(custmerName, forKey: "CustomerName")
            lead.setValue(mobileNumber, forKey: "MobileNumber")
            lead.setValue(seriesNumber, forKey: "SeriesNumber")
            lead.setValue(productName, forKey: "ProductName")
            lead.setValue(leadDate, forKey: "LeadDate")
            lead.setValue(status, forKey: "Status")
            lead.setValue(address, forKey: "Address")
            print(lead)
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

    }

    @IBAction func generateLeadAction(_ sender: UIButton) {
        isGenerateLead = true
        self.performSegue(withIdentifier: "leadSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leadSegue" {
            let vc = segue.destination as? LeadViewController
            vc?.isGenerateLead = isGenerateLead
            if self.leads.count > 0 {
                vc?.lead = self.leads[selectedLead]
            }
        } else if segue.identifier == "leadDetailSegue" {
            let vc = segue.destination as? LeadDetailViewController
            if self.leads.count > 0 {
                vc?.lead = self.leads[selectedLead]
            }
        }
    }
    
    func editLead(button: UIButton) {
        selectedLead = button.tag
        isGenerateLead = false
        self.performSegue(withIdentifier: "leadSegue", sender: nil)
    }
    
    func viewLead(button: UIButton) {
        selectedLead = button.tag
        self.performSegue(withIdentifier: "leadDetailSegue", sender: nil)
        
    }

}
