//
//  LeadViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 06/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class LeadViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    @IBOutlet weak var leadTableView: UITableView!
    @IBOutlet weak var tabSelectionView: UIView!
    @IBOutlet weak var generateLeadButton: UIButton!
    @IBOutlet weak var searchLeadButton: UIButton!
    
    var isGenerateLead = false
    
    var generateLeadCell = GenerateLeadTableViewCell()
    var searchLeadCell = SearchLeadTableViewCell()
    var currentElement = ""
    var userDetails = ServerManager.sharedInstance().userDetailsDict
    
    var city = NSMutableDictionary()
    var cityName = ""
    var cityID = ""
    var cityList = [NSMutableDictionary]()
    var region = ""
    var responseCode = ""
    var isLeadCreated = false
    
    var statusArray = [String]()
    var statusDict = NSMutableDictionary()
    var statusString = ""
    var sourceArray = [String]()
    
    var product = NSMutableDictionary()
    var productNameDict = NSMutableDictionary()
    var productList = [NSMutableDictionary]()
    var searchProductList = [NSMutableDictionary]()
    var productNameList = [NSMutableDictionary]()
    var allProductList = [NSMutableDictionary]()
    var productNameArray = [String]()
    
    
    var productName = ""
    var modelName = ""
    var modelDescription = ""
    var modelList = [String]()
    var isSearch = false
    
    var lead = NSMutableDictionary()
    var leadId = ""
    var custmerName = ""
    var mobileNumber = ""
    var emailId = ""
    var alternateMobileNo = ""
    var leadSource = ""
    var subSource = ""
    var pinCode = ""
    var address = ""
    var seriesNumber = ""
    var fixedDemoDate = ""
    var followupDate = ""
    var status = ""
    var leadDate = ""
    var leads = [NSMutableDictionary]()
    var isSource = false
    var  selectedLead = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // leadTableView.register(GenerateLeadTableViewCell as UITableViewCell, forCellReuseIdentifier: "generateLeadCell")
        // Do any additional setup after loading the view.
        
        self.leadTableView.register(UINib(nibName: "GenerateLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "generateLeadCell")
        self.leadTableView.register(UINib(nibName: "SearchLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "searchLeadTableViewCell")
        
        self.title = "Blue Star"
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.tabSelectionView.frame = CGRect(x: self.generateLeadButton.frame.origin.x, y: self.generateLeadButton.frame.origin.y + self.generateLeadButton.frame.size.height , width: self.generateLeadButton.frame.size.width, height: 2)
        self.tabSelectionView.layoutIfNeeded()
        self.leadTableView.register(UINib(nibName: "AssignedLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "assignedLeadCell")
        self.view.layoutIfNeeded()
        if isGenerateLead {
            self.generateLeadButton.setTitle("Generate Lead", for: .normal)
        } else {
            self.generateLeadButton.setTitle("Update Lead", for: .normal)
        }
        addCustomNavigationButton()
        self.leadTableView.layoutIfNeeded()
        self.leadTableView.updateConstraintsIfNeeded()
    }
    
    @IBAction func generateLeadAction(_ sender: UIButton) {
        isSearch = false
        self.leadTableView.layoutIfNeeded()
        leadTableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.1) {
            self.searchLeadButton.setTitleColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.generateLeadButton.setTitleColor(UIColor.white, for: .normal)
            self.tabSelectionView.frame = CGRect(x: self.generateLeadButton.frame.origin.x, y: self.generateLeadButton.frame.origin.y + 1 + self.generateLeadButton.frame.size.height , width: self.generateLeadButton.frame.size.width, height: 1)
        }
        self.leadTableView.reloadData()
        self.leadTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        
    }
    @IBAction func searchLeadAction(_ sender: UIButton) {
        isSearch = true
        if searchProductList.count == 0 {
            let dict = NSMutableDictionary()
            dict.setValue("Not Selected", forKey: "ProductName")
            searchProductList = [NSMutableDictionary]()
            searchProductList.append(dict)
            
        }
        self.leadTableView.layoutIfNeeded()
        self.leadTableView.reloadData()
        self.leadTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        
        
        UIView.animate(withDuration: 0.1) {
            self.generateLeadButton.setTitleColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.searchLeadButton.setTitleColor(UIColor.white, for: .normal)
            self.tabSelectionView.frame = CGRect(x: self.searchLeadButton.frame.origin.x, y: self.searchLeadButton.frame.origin.y + 1 + self.searchLeadButton.frame.size.height , width: self.searchLeadButton.frame.size.width, height: 1)
            self.getDetailsApi()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = false
        addRightNavigationBarButton()
        getCityList()
        NotificationCenter.default.addObserver(self, selector: #selector(LeadViewController.getDetailsApi), name: NSNotification.Name(rawValue: "ValueSelectedNotification"), object: nil)
    }
    
    func getDetailsApi() {
        if (generateLeadCell.cityTextField.text?.characters.count)! > 2 {
            ServerManager.sharedInstance().getCityDetails(cityName: generateLeadCell.cityTextField.text!, completion: { (result, data) in
                let parser = XMLParser(data: data)
                parser.delegate = self
                let success:Bool = parser.parse()
                if success {
                    DispatchQueue.main.async {
                        self.generateLeadCell.regionTextField.text = self.region
                    }
                }
                
            })
        }
        
        if let productName = generateLeadCell.productNameTextField.text {
            if productName.characters.count > 2 {
                modelList = [String]()
                for product in allProductList {
                    if product.value(forKey: "ProductName") as? String ==  productName {
                        if let modelName = product.value(forKey: "ModelName") as? String {
                            if !modelList.contains(modelName){
                                modelList.append(modelName)
                            }
                            
                        }
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.generateLeadCell.productModelTextField.pickerData = self.modelList
                    self.productNameArray = [String]()
                    for product in self.productNameList {
                        if let productName = product.value(forKey: "ProductName") as? String {
                            self.productNameArray.append(productName)
                        }
                    }
                    if self.productNameArray.count > 0 {
                       // self.leadTableView.reloadData()
                    }
                    
                    if self.isSearch {
                        // self.searchLeadCell.productName.pickerData = self.productNameArray
                    }
                }
            }
        }
        
        
    }
    
    func getCityList() {
        ServerManager.sharedInstance().getCityList { (resutl, data) in
            let parser = XMLParser(data: data)
            parser.delegate = self
            let success:Bool = parser.parse()
            if success {
                DispatchQueue.main.async {
                    print(self.cityList)
                    self.generateLeadCell.cityTextField.data = self.cityList
                }
                self.getProductDetails()
            }
            
        }
    }
    
    func getProductDetails () {
        ServerManager.sharedInstance().getProductDetails { (result, data) in
            let parser = XMLParser(data: data)
            parser.delegate = self
            let success:Bool = parser.parse()
            if success {
                DispatchQueue.main.async {
                    print(self.statusArray)
                    self.generateLeadCell.statusTextField.statusData = self.statusArray
                    self.generateLeadCell.productNameTextField.data = self.productList
                    self.generateLeadCell.enquiryTextField.statusData = self.sourceArray
                    self.getDetailsApi()
                }
                
            }
        }
        
    }
    
    func addRightNavigationBarButton() {
        
        
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action:  #selector(nextButtonClicked))
        rightBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName: UIColor.white], for: UIControlState.normal)
        rightBarButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray], for: UIControlState.disabled)
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
    func logout() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func punchout() {
        print(self.navigationController?.viewControllers)
        let vc = storyboard?.instantiateViewController(withIdentifier: "attendenceVC")
        for controller in (navigationController?.viewControllers)! {
            if controller.isKind(of: AttendanceViewController.self) {
                UserDefaults.standard.removeObject(forKey: "isAttendenceMarked")
                UserDefaults.standard.removeObject(forKey: "CurrentDate")
                navigationController?.popToViewController(controller, animated: true)
            }
        }
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    func nextButtonClicked() {
        let customView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 141, y: 0, width: 140 , height: 80))
        let logoutButton = UIButton(type: UIButtonType.system)
        //Set a frame for the button. Ignored in AutoLayout/ Stack Views
        logoutButton.frame = CGRect(x: 0, y: 0, width: 140, height: 40)
        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.setTitleColor(UIColor.black, for: .normal)
        logoutButton.addTarget(self, action:#selector(logout), for: .touchUpInside)
        
        let punchoutButton = UIButton(type: UIButtonType.system)
        //Set a frame for the button. Ignored in AutoLayout/ Stack Views
        punchoutButton.frame = CGRect(x: 0, y: 40, width: 140, height: 40)
        punchoutButton.setTitle("Punch out", for: .normal)
        punchoutButton.setTitleColor(UIColor.black, for: .normal)
        punchoutButton.addTarget(self, action: #selector(punchout), for: .touchUpInside)
        
        customView.addSubview(logoutButton)
        customView.addSubview(punchoutButton)
        customView.backgroundColor = UIColor.white
        customView.layer.cornerRadius = 2.0
        customView.layer.borderColor = UIColor.lightGray.cgColor
        customView.layer.borderWidth = 1.0
        customView.clipsToBounds = true
        //give color to the view
        //customView.center = self.view.center
        self.view.addSubview(customView)
        
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return  self.leads.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearch {
            if indexPath.row == 0 {
                
                var cell = leadTableView.dequeueReusableCell(withIdentifier: "searchLeadTableViewCell", for: indexPath) as? SearchLeadTableViewCell
                if cell == nil {
                    cell = (leadTableView.dequeueReusableCell(withIdentifier: "searchLeadTableViewCell", for: indexPath) as? SearchLeadTableViewCell)!
                    
                }
                searchLeadCell = cell!
                searchProductList.append(contentsOf: productList)
                cell?.productName.data = searchProductList
                cell?.selectionStyle = .none
                cell?.layer.masksToBounds = false
                cell?.layer.shadowColor = UIColor.black.cgColor
                cell?.layer.shadowOpacity = 0.2
                cell?.layer.opacity = 0.3
                cell?.layer.shadowOffset = CGSize(width: 0, height: 2)
                cell?.layer.shadowRadius = 2
                cell?.clipsToBounds = false
                
                cell?.searchButtion.addTarget(self, action: #selector(self.searchLead(button:)), for: .touchUpInside)
                cell?.clearButton.addTarget(self, action: #selector(self.clearAction), for: .touchUpInside)
                return  cell!
                
            } else {
                var cell = leadTableView.dequeueReusableCell(withIdentifier: "assignedLeadCell", for: indexPath) as? AssignedLeadTableViewCell
                if cell == nil {
                    cell = (leadTableView.dequeueReusableCell(withIdentifier: "assignedLeadCell", for: indexPath) as? AssignedLeadTableViewCell)!
                }
                if let customerName = self.leads[indexPath.row-1].value(forKey: "CustomerName") as? String {
                    cell?.custName = customerName
                }
                
                if let mobileNo = self.leads[indexPath.row-1].value(forKey: "MobileNumber") as? String {
                    cell?.mobileNumber = mobileNo
                }
                
                if let productName = self.leads[indexPath.row-1].value(forKey: "ProductName") as? String {
                    cell?.productName = productName
                }
                
                cell?.editLeadButton.addTarget(self, action: #selector(self.editLead(button:)), for: .touchUpInside)
                cell?.editLeadButton.tag = indexPath.row - 1
                cell?.viewLeadButton.addTarget(self, action: #selector(self.viewLead(button:)), for: .touchUpInside)
                cell?.viewLeadButton.tag = indexPath.row - 1
                
                return  cell!
            }
        } else {
            var cell = leadTableView.dequeueReusableCell(withIdentifier: "generateLeadCell", for: indexPath) as? GenerateLeadTableViewCell
            if cell == nil {
                cell = (leadTableView.dequeueReusableCell(withIdentifier: "generateLeadCell", for: indexPath) as? GenerateLeadTableViewCell)!
            }
            
            cell?.selectionStyle = .none
            cell?.updateButton.addTarget(self, action: #selector(self.saveLeadAction(button:)), for: .touchUpInside)
            cell?.clearButton.addTarget(self, action: #selector(self.clearAction), for: .touchUpInside)
            if cell?.statusTextField.text == "Follow Up" {
                cell?.followupDateTextField.isHidden = false
            } else {
                cell?.followupDateTextField.isHidden = true
            }
            if isGenerateLead {
                cell?.updateButton.setTitle("Save Lead", for: .normal)
                cell?.leadNumberLabel.isHidden = true
                
            } else {
                cell?.updateButton.setTitle("Update", for: .normal)
                cell?.leadNumberLabel.isHidden = false
                
                if let customerName = lead.value(forKey: "CustomerName") as? String {
                    cell?.customerNameTextField.text = customerName
                }
                if let customerMobileNoTextField = lead.value(forKey: "MobileNumber") as? String {
                    cell?.customerMobileNoTextField.text = customerMobileNoTextField
                }
                
                if let status = lead.value(forKey: "Stauts") as? String {
                    cell?.stateTextField.text = status
                }
                
                if let address = lead.value(forKey: "Address") as? String {
                    cell?.addressTextField.text = address
                }
                
                if let seriesNumber =  self.lead.value(forKey: "SeriesNumber") as? String {
                    cell?.leadNumberLabel.text = "Lead No.: \(seriesNumber)"
                }
                
                
                if let productName =  self.lead.value(forKey: "ProductName") as? String {
                    cell?.productNameTextField.text = productName
                }
            }
            generateLeadCell = cell!
            
            generateLeadCell.layoutIfNeeded()
            return  cell!
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func saveLeadAction(button: UIButton) {
        var roleId = ""
        var createdBy = ""
        
        if let location = getCurrentLocation() {
            if let roleID = userDetails.value(forKey: "RoleID") as? String, let createdByUser = userDetails.value(forKey: "ID") as? String {
                roleId = roleID
                createdBy = createdByUser
                
            }
            
            
            let lattitude = "\(location.coordinate.latitude)"
            let longitude = "\(location.coordinate.longitude)"
            
            if (generateLeadCell.customerNameTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Customer Name can not be blank")
            } else if (generateLeadCell.customerMobileNoTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Mobile No. can not be blank")
            }else if (generateLeadCell.customerMobileNoTextField.text?.characters.count)! > 10 || (generateLeadCell.customerMobileNoTextField.text?.characters.count)! < 10 {
                showAlert(title: "Error", message: "Mobile No. should be 10 digit")
            }else if (generateLeadCell.alternameMobileNoTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Alternate Mobile No. can not be blank")
            } else if (generateLeadCell.alternameMobileNoTextField.text?.characters.count)! > 10 || (generateLeadCell.alternameMobileNoTextField.text?.characters.count)! < 10 {
                showAlert(title: "Error", message: "Alternate Mobile No. should be 10 digit")
            }else if (generateLeadCell.stateTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Location can not be blank")
            } else if (generateLeadCell.pinCodeTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Pincode can not be blank")
            } else if (generateLeadCell.pinCodeTextField.text?.characters.count != 6) {
                showAlert(title: "Error", message: "Pincode should be of 6 digits")
            } else if (generateLeadCell.emailIdTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Email ID can not be blank")
            } else if !generateLeadCell.emailIdTextField.isValidEmail().0 {
                showAlert(title: "Error", message: generateLeadCell.emailIdTextField.isValidEmail().1)
            }else if (generateLeadCell.swcNameTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "SWC Name can not be blank")
            } else if (generateLeadCell.demoDateTextFiled.text?.isEmpty)! {
                showAlert(title: "Error", message: "Demo date can not be blank")
            } else if generateLeadCell.statusTextField.text == "Follow Up" && (generateLeadCell.followupDateTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Follow Up date can not be blank")
                
            } else if (generateLeadCell.commentTextField.text?.isEmpty)! {
                showAlert(title: "Error", message: "Comments can not be blank")
            }  else {
                var dict: [String: String] = [
                    "CustomerName": generateLeadCell.customerNameTextField.text!,
                    "EmailID": generateLeadCell.emailIdTextField.text!,
                    "MobileNumber": generateLeadCell.customerMobileNoTextField.text!,
                    "AlternateNumber": generateLeadCell.alternameMobileNoTextField.text!,
                    "Pincode": generateLeadCell.pinCodeTextField.text!,
                    "CityName": generateLeadCell.cityTextField.text!,
                    "Address": generateLeadCell.addressTextField.text!,
                    "LeadSource": generateLeadCell.enquiryTextField.text!,
                    
                    "ProductName": generateLeadCell.productNameTextField.text!,
                    "ModelName": generateLeadCell.productModelTextField.text!,
                    "SwcName": generateLeadCell.swcNameTextField.text!,
                    "DemoFixedDate": generateLeadCell.demoDateTextFiled.text!,
                    "FollowUpDate": generateLeadCell.followupDateTextField.text!,
                    "LeadStatus": generateLeadCell.statusTextField.text!,
                    "Comments": generateLeadCell.commentTextField.text!,
                    "RoleID": roleId,
                    "CreatedBy": createdBy,
                    "Longitude": longitude,
                    "Latitude":  lattitude,
                    "LeadRaisedAddress":  generateLeadCell.addressTextField.text!
                ]
                showProgressLoader()
                if isGenerateLead {
                    ServerManager.sharedInstance().generateLead(leadDetails: dict) { (result, data) in
                        
                        if result == "Request time out error...!!!" {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error", message: result)
                            }

                        } else {
                        let parser = XMLParser(data: data)
                        parser.delegate = self
                        let success:Bool = parser.parse()
                        DispatchQueue.main.async {
                            self.hideProgressLoader()
                        }
                        
                        if success {
                            DispatchQueue.main.async {
                                // self.clearAction()
                                if self.responseCode == "200" {
                                    self.showAlert(title: "Sucessful", message: "Lead Created Sucessfully")
                                }
                                
                            }
                        }
                        
                    }
                }
                } else {
                    if let seriesNumber = self.lead.value(forKey: "SeriesNumber") as? String {
                        dict["SeriesNumber"] = seriesNumber
                    }
                    ServerManager.sharedInstance().updateLead(leadDetails: dict) { (result, data) in
                        if result == "Request time out error...!!!" {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error", message: result)
                            }
                            
                        }else {
                        let parser = XMLParser(data: data)
                        parser.delegate = self
                        let success:Bool = parser.parse()
                        DispatchQueue.main.async {
                            self.hideProgressLoader()
                        }
                        
                        if success {
                            DispatchQueue.main.async {
                                // self.clearAction()
                                if self.responseCode == "200" {
                                    self.showAlert(title: "Sucessful", message: "Lead updated Sucessfully")
                                }
                                
                            }
                        }
                        
                    }
                }
                
                }
                
                
            }
            
        }
        
    }
    
    func searchLead(button: UIButton) {
        let pincode = searchLeadCell.pincodeTextField.text!
        if (searchLeadCell.pincodeTextField.text?.characters.count)! > 0 {
            if pincode.characters.count == 6 {
                ServerManager.sharedInstance().getPincodeDetails(pincode: pincode, completion: { (result, data) in
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    let success:Bool = parser.parse()
                    if success {
                        self.getLeads()
                    }
                })
                
            }
            
        } else {
            self.getLeads()
            
        }
        
    }
    
    func getLeads() {
        self.leads.removeAll()
        let custmerName = searchLeadCell.customerNameTextField.text!
        let leadId = searchLeadCell.leadIdTextField.text!
        let phoneNumber = searchLeadCell.mobileTextField.text!
        let pinCode = searchLeadCell.pincodeTextField.text!
        var productName = searchLeadCell.productName.text!
        if productName == "Not Selected" {
            productName = ""
        }
        let status = searchLeadCell.statusTextField.text!
        showProgressLoader()
        ServerManager.sharedInstance().getLeads(leadId: leadId, customerName: custmerName, phoneNumber: phoneNumber, pinCode: pinCode, productName: productName, status: status) { (result, data) in
            let parser = XMLParser(data: data)
            parser.delegate = self
            let success:Bool = parser.parse()
            DispatchQueue.main.async {
                self.hideProgressLoader()
            }
            if success {
                DispatchQueue.main.async {
                    if self.leads.count == 0 {
                        self.showToast(message: "No Leads found.")
                    }
                    self.leadTableView.reloadData()
                    //self.clearAction()
                }
            }
        }
        
    }
    
    func clearAction()  {
        generateLeadCell.customerNameTextField.text = ""
        generateLeadCell.emailIdTextField.text = ""
        generateLeadCell.customerMobileNoTextField.text = ""
        generateLeadCell.alternameMobileNoTextField.text = ""
        generateLeadCell.pinCodeTextField.text = ""
        generateLeadCell.cityTextField.text = ""
        generateLeadCell.addressTextField.text = ""
        generateLeadCell.enquiryTextField.text = ""
        generateLeadCell.productNameTextField.text = ""
        generateLeadCell.productModelTextField.text = ""
        generateLeadCell.swcNameTextField.text = ""
        generateLeadCell.demoDateTextFiled.text = ""
        generateLeadCell.followupDateTextField.text = ""
        generateLeadCell.statusTextField.text = ""
        generateLeadCell.commentTextField.text = ""
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement =  elementName
        
        if elementName == "Status" {
            isSource = false
        }
        if elementName == "Sources" {
            isSource = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if currentElement == "ResponseCode" {
            //if isLeadCreated {
             //   responseCode  = string
             //   isLeadCreated = false
            //} else if !isGenerateLead {
                responseCode  = string
            //}
        }
        
        
        if currentElement == "ID" {
            cityID = string
        }
        if currentElement == "Name" {
            cityName = string
        }
        
        if currentElement == "CityRegion" {
            region = string
        }
        if currentElement == "string" {
            statusString = string
        }
        
        
        
        if currentElement == "ProductName" {
            productName = string
        }
        
        if currentElement == "ModelName" {
            modelName = string
        }
        if currentElement == "ModelDescription" {
            modelDescription = string
        }
        if currentElement == "SeriesNumber" {
            seriesNumber = string
        }
        if currentElement == "CustomerName" {
            custmerName = string
        }
        if currentElement == "MobileNumber" {
            mobileNumber = string
        }
        
        if currentElement == "EmailID" {
            emailId = string
        }
        if currentElement == "AlternateMobileNumber" {
            alternateMobileNo = string
        }
        if currentElement == "Pincode" {
            pinCode = string
        }
        if currentElement == "LeadSource" {
            leadSource = string
        }
        
        if currentElement == "SubSource" {
            subSource = string
        }
        
        if currentElement == "Status" {
            status = string
        }
        if currentElement == "LeadDate" {
            leadDate = string
        }
        if currentElement == "DemoFixedDate" {
            fixedDemoDate = string
        }
        if currentElement == "FollowUpFixedDate" {
            followupDate = string
        }
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "City" {
            city = NSMutableDictionary()
            city.setValue(cityID, forKey: "ID")
            city.setValue(cityName, forKey: "Name")
            print(city)
            cityList.append(city)
        }
        
        if elementName == "string" {
            if isSource {
                sourceArray.append(statusString)
            } else {
                statusArray.append(statusString)
            }
            
        }
        
        if (elementName == "ProductName") || (elementName == "ModelName") || (elementName == "ModelDescription") {
            
            if productName.characters.count > 1  && modelName.characters.count > 1 && modelDescription.characters.count > 1 {
                product = NSMutableDictionary()
                productNameDict = NSMutableDictionary()
                productNameDict.setValue(productName, forKey: "ProductName")
                
                if productNameList.contains(productNameDict) {
                    productNameDict = NSMutableDictionary()
                } else {
                    product.setValue(productName, forKey: "ProductName")
                    product.setValue(modelName, forKey: "ModelName")
                    product.setValue(modelDescription, forKey: "ModelDescription")
                    print(product)
                    productList.append(product)
                    productNameList.append(productNameDict)
                    
                }
                
                product.setValue(productName, forKey: "ProductName")
                product.setValue(modelName, forKey: "ModelName")
                product.setValue(modelDescription, forKey: "ModelDescription")
                allProductList.append(product)
                
                productName = ""
                modelDescription = ""
                modelName = ""
                
            }
        }
        if elementName == "Lead" {
            lead = NSMutableDictionary()
            lead.setValue(custmerName, forKey: "CustomerName")
            lead.setValue(mobileNumber, forKey: "MobileNumber")
            lead.setValue(seriesNumber, forKey: "SeriesNumber")
            lead.setValue(productName, forKey: "ProductName")
            lead.setValue(leadDate, forKey: "LeadDate")
            lead.setValue(status, forKey: "Status")
            lead.setValue(address, forKey: "Address")
            lead.setValue(emailId, forKey: "EmailID")
            lead.setValue(alternateMobileNo, forKey: "AlternateMobileNumber")
            lead.setValue(pinCode, forKey: "Pincode")
            lead.setValue(leadSource, forKey: "LeadSource")
            lead.setValue(leadDate, forKey: "SubSource")
            lead.setValue(fixedDemoDate, forKey: "DemoFixedDate")
            lead.setValue(followupDate, forKey: "FollowUpFixedDate")
            print(lead)
            leads.append(lead)
        }
        
        
    }
    
    func editLead(button: UIButton) {
        selectedLead = button.tag
        isGenerateLead = false
        isSearch = false
        self.leadTableView.layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            self.searchLeadButton.setTitleColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.generateLeadButton.setTitleColor(UIColor.white, for: .normal)
            self.tabSelectionView.frame = CGRect(x: self.generateLeadButton.frame.origin.x, y: self.generateLeadButton.frame.origin.y + 1 + self.generateLeadButton.frame.size.height , width: self.generateLeadButton.frame.size.width, height: 1)
        }
        leadTableView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        self.leadTableView.reloadData()
        // self.performSegue(withIdentifier: "leadSegue", sender: nil)
    }
    
    func viewLead(button: UIButton) {
        selectedLead = button.tag
        self.performSegue(withIdentifier: "leadDetailSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leadSegue" {
            let vc = segue.destination as? LeadViewController
            vc?.isGenerateLead = false
            vc?.lead = self.leads[selectedLead]
        } else if segue.identifier == "leadDetailSegue" {
            let vc = segue.destination as? LeadDetailViewController
            vc?.lead = self.leads[selectedLead]
            
        }
    }
}
