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
    @IBOutlet weak var generateLeadHeightConstrint: NSLayoutConstraint!
    
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
    var swcName = ""
    var seriesNumber = ""
    var fixedDemoDate = ""
    var followupDate = ""
    var status = ""
    var leadDate = ""
    var comments = ""
    
    var leads = [NSMutableDictionary]()
    var isSource = false
    var  selectedLead = 0
    var inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    var menuView = UIView()
    var isMenuClicked = false
    
    var searchLeadMobileNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        registerCell()
        self.title = "Blue Star"
        self.navigationController?.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        
        if isGenerateLead {
            self.tabSelectionView.frame = CGRect(x: self.searchLeadButton.frame.origin.x, y: self.searchLeadButton.frame.origin.y + self.searchLeadButton.frame.size.height , width: self.searchLeadButton.frame.size.width, height: 2)
            self.tabSelectionView.layoutIfNeeded()
            isSearch = true
            generateLeadHeightConstrint.constant = 50
            self.generateLeadButton.setTitle("Generate Lead", for: .normal)
        } else {
            self.generateLeadButton.setTitle("Update Lead", for: .normal)
            isGenerateLead = false
            generateLeadAnimation()
            isSearch = false
            generateLeadHeightConstrint.constant = 0

        }
        
        if !isGenerateLead {
             addCustomNavigationButton()
        }
        getProductDetails()
        
       //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        addRightNavigationBarButton()
        
        self.leadTableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(LeadViewController.getDetailsApi), name: NSNotification.Name(rawValue: "ValueSelectedNotification"), object: nil)
    }

    func registerCell() {
        self.leadTableView.register(UINib(nibName: "GenerateLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "generateLeadCell")
        self.leadTableView.register(UINib(nibName: "SearchLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "searchLeadTableViewCell")
        self.leadTableView.register(UINib(nibName: "AssignedLeadTableViewCell", bundle: nil), forCellReuseIdentifier: "assignedLeadCell")
    }
    
    func generateLeadAnimation() {
        isSearch = false
        generateLeadHeightConstrint.constant = 0

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
    
    @IBAction func generateLeadAction(_ sender: UIButton) {
        generateLeadAnimation()
        getCityList()
    }
    
    @IBAction func searchLeadAction(_ sender: UIButton) {
        isSearch = true
        generateLeadHeightConstrint.constant = 50

        if searchProductList.count == 0 {
            let dict = NSMutableDictionary()
            dict.setValue("Not Selected", forKey: "ProductName")
            searchProductList = [NSMutableDictionary]()
            searchProductList.append(dict)
        }
        UIView.animate(withDuration: 0.1) {
            self.generateLeadButton.setTitleColor(UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.searchLeadButton.setTitleColor(UIColor.white, for: .normal)
            self.tabSelectionView.frame = CGRect(x: self.searchLeadButton.frame.origin.x, y: self.searchLeadButton.frame.origin.y + 1 + self.searchLeadButton.frame.size.height , width: self.searchLeadButton.frame.size.width, height: 1)
           // self.getDetailsApi()
            self.leadTableView.reloadData()
        }
        
    }
    
    func getDetailsApi() {
        
        if let cell = generateLeadCell as? GenerateLeadTableViewCell {
            if let cityName = cell.cityTextField.text {
                if (cityName.characters.count) > 2 {
                    ServerManager.sharedInstance().getCityDetails(cityName: cell.cityTextField.text!, completion: { (result, data) in
                        self.parseData(data: data, result: result, apiName: "cityDetails")
                        
                    })
                }
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
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            self.leadTableView.reloadData()
        }
    }
    
    func getCityList() {
        ServerManager.sharedInstance().getCityList { (result, data) in
            self.parseData(data: data, result: result, apiName: "cityList")
            self.getProductDetails()
        }
    }
    
    func getProductDetails () {
        ServerManager.sharedInstance().getProductDetails { (result, data) in
            self.parseData(data: data, result: result, apiName: "productDetails")
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
        isMenuClicked = !isMenuClicked
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func assignedLeadsAction() {
        isMenuClicked = !isMenuClicked
        self.menuView.removeFromSuperview()
        self.performSegue(withIdentifier: "assignedLeadSegue", sender: nil)
       // self.navigationController?.popToRootViewController(animated: true)
    }

    
    func punchout() {
        isMenuClicked = !isMenuClicked
        let formatter = DateFormatter()
        formatter.dateFormat = self.inputDateFormat
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "'at' h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if let dateTime = UserDefaults.standard.value(forKey: "CurrentDate") as? Date {
            let isAttendenceMarked =  UserDefaults.standard.bool(forKey: "isAttendenceMarked")
            if formatter.calendar.isDateInToday(dateTime) && isAttendenceMarked && UserDefaults.standard.bool(forKey: "isPunchOut") {
                DispatchQueue.main.async {
                    self.showToast(message: punchOutMessage)
                }
                UserDefaults.standard.set(false, forKey: "isFromPunchOut")
            } else {
                gotoAttendentPunchOut()
            }
            
        } else {
            gotoAttendentPunchOut()
        }
    }
    
    func gotoAttendentPunchOut() {
        for controller in (navigationController?.viewControllers)! {
            if controller.isKind(of: AttendanceViewController.self) {
                UserDefaults.standard.set(false, forKey: "isPunchOut")
                UserDefaults.standard.set(true, forKey: "isFromPunchOut")
                navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    func nextButtonClicked() {
        
        
        isMenuClicked = !isMenuClicked
        if isMenuClicked {
            menuView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 141, y: 0, width: 160 , height: 120))
            
            let assignedLeadButton = UIButton(type: UIButtonType.system)
            //Set a frame for the button. Ignored in AutoLayout/ Stack Views
            assignedLeadButton.frame = CGRect(x: 0, y: 0, width: 160, height: 40)
            assignedLeadButton.setTitle("Assigned Leads", for: .normal)
            assignedLeadButton.setTitleColor(UIColor.black, for: .normal)
            assignedLeadButton.addTarget(self, action:#selector(assignedLeadsAction), for: .touchUpInside)
            
            let logoutButton = UIButton(type: UIButtonType.system)
            //Set a frame for the button. Ignored in AutoLayout/ Stack Views
            logoutButton.frame = CGRect(x: 0, y: 40, width: 160, height: 40)
            logoutButton.setTitle("Log out", for: .normal)
            logoutButton.setTitleColor(UIColor.black, for: .normal)
            logoutButton.addTarget(self, action:#selector(logout), for: .touchUpInside)
            
            let punchoutButton = UIButton(type: UIButtonType.system)
            //Set a frame for the button. Ignored in AutoLayout/ Stack Views
            punchoutButton.frame = CGRect(x: 0, y: 80, width: 160, height: 40)
            punchoutButton.setTitle("Punch out", for: .normal)
            punchoutButton.setTitleColor(UIColor.black, for: .normal)
            punchoutButton.addTarget(self, action: #selector(punchout), for: .touchUpInside)
            
            menuView.addSubview(assignedLeadButton)
            menuView.addSubview(logoutButton)
            menuView.addSubview(punchoutButton)
            menuView.backgroundColor = UIColor.white
            menuView.layer.cornerRadius = 2.0
            menuView.layer.borderColor = UIColor.lightGray.cgColor
            menuView.layer.borderWidth = 1.0
            menuView.clipsToBounds = true
            self.view.addSubview(menuView)
            self.navigationController?.isNavigationBarHidden = false
           self.menuView.isHidden = false
        } else {
            menuView.removeFromSuperview()
            self.menuView.isHidden = true
            
        }
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
                if searchProductList.count == 1 {
                    searchProductList.append(contentsOf: productList)
                }
                cell?.productName.data = searchProductList
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
                cell?.followupDateTextField.text = ""
            }
            
            if isGenerateLead {
                cell?.updateButton.setTitle("Save Lead", for: .normal)
                cell?.leadNumberLabel.isHidden = true
                
            } else {
                cell?.updateButton.setTitle("Update", for: .normal)
                cell?.leadNumberLabel.isHidden = false
            }
            
            
            if let customerName = lead.value(forKey: "CustomerName") as? String  {
                if (cell?.customerNameTextField.text?.isEmpty)! {
                    cell?.customerNameTextField.text = customerName
                }
                
            }
            if let alternateNumber = lead.value(forKey: "AlternateMobileNumber") as? String  {
                if (cell?.alternameMobileNoTextField.text?.isEmpty)! {
                    cell?.alternameMobileNoTextField.text = alternateNumber
                }
                
            }
            
            if let comments = lead.value(forKey: "Comments") as? String  {
                if (cell?.commentTextField.text?.isEmpty)! {
                    cell?.commentTextField.text = comments
                }
            }
            
            if let customerMobileNoTextField = lead.value(forKey: "MobileNumber") as? String {
                if (cell?.customerMobileNoTextField.text?.isEmpty)! {
                    cell?.customerMobileNoTextField.text = customerMobileNoTextField
                }
            } else {
                cell?.customerMobileNoTextField.text = searchLeadMobileNo
            }
            
            if let status = lead.value(forKey: "Stauts") as? String {
                
                if (cell?.stateTextField.text?.isEmpty)! {
                    cell?.stateTextField.text = status
                }
            }
            
            if let address = lead.value(forKey: "Address") as? String {
                if (cell?.addressTextField.text?.isEmpty)! {
                    cell?.addressTextField.text = address
                }
            }
            if let pincode = lead.value(forKey: "Pincode") as? String  {
                if (cell?.pinCodeTextField.text?.isEmpty)! {
                    cell?.pinCodeTextField.text = pincode
                }
                
            }
            
            if let cityName =  self.lead.value(forKey: "CityName") as? String {
                if (cell?.cityTextField.text?.isEmpty)! {
                    cell?.cityTextField.text = cityName
                }
            }
            if let location =  self.lead.value(forKey: "Location") as? String {
                if (cell?.stateTextField.text?.isEmpty)! {
                    cell?.followupDateTextField.text = location
                }
            }
            
            if let emailId =  self.lead.value(forKey: "EmailID") as? String {
                if (cell?.emailIdTextField.text?.isEmpty)! {
                    cell?.emailIdTextField.text = emailId
                }
            }
            if let source =  self.lead.value(forKey: "LeadSource") as? String {
                if (cell?.enquiryTextField.text?.isEmpty)! {
                    cell?.enquiryTextField.text = source
                }
            }


            
            if let seriesNumber =  self.lead.value(forKey: "SeriesNumber") as? String {
                if (cell?.leadNumberLabel.text?.isEmpty)! {
                    cell?.leadNumberLabel.text = "Lead No.: \(seriesNumber)"
                }
            }
            if let productName =  self.lead.value(forKey: "ProductName") as? String {
                if (cell?.productNameTextField.text?.isEmpty)! {
                    cell?.productNameTextField.text = productName
                }
            }
            
            if let swcName = lead.value(forKey: "SwcName") as? String {
                if (cell?.swcNameTextField.text?.isEmpty)! {
                    cell?.swcNameTextField.text = swcName
                }
            }
            if let modelName = lead.value(forKey: "ModelName") as? String  {
                if (cell?.productModelTextField.text?.isEmpty)! {
                    cell?.productModelTextField.text = modelName
                }
            }
            
            if let demoFixedDate =  self.lead.value(forKey: "DemoFixedDate") as? String {
                if (cell?.demoDateTextFiled.text?.isEmpty)! {
                    cell?.demoDateTextFiled.text = demoFixedDate
                }
            }
            if let followupDate =  self.lead.value(forKey: "FollowUpDate") as? String {
                if (cell?.followupDateTextField.text?.isEmpty)! {
                    cell?.followupDateTextField.text = followupDate
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
        if let roleID = userDetails.value(forKey: "RoleID") as? String, let createdByUser = userDetails.value(forKey: "ID") as? String {
            roleId = roleID
            createdBy = createdByUser
        }
        
        if (generateLeadCell.customerNameTextField.text?.isEmpty)! {
            showAlert(title: "Error", message: "Customer Name can not be blank")
        } else if (generateLeadCell.customerMobileNoTextField.text?.isEmpty)! {
            showAlert(title: "Error", message: "Mobile No. can not be blank")
        }else if (generateLeadCell.customerMobileNoTextField.text?.characters.count)! > 10 || (generateLeadCell.customerMobileNoTextField.text?.characters.count)! < 10 {
            showAlert(title: "Error", message: "Mobile No. should be 10 digit")
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
            
            if ((generateLeadCell.alternameMobileNoTextField.text?.characters.count)! > 0)  && (generateLeadCell.alternameMobileNoTextField.text?.characters.count != 10) {
                showAlert(title: "Error", message: "Alternate Mobile No. should be 10 digit")
            } else if !(generateLeadCell.emailIdTextField.text?.isEmpty)! && !generateLeadCell.emailIdTextField.isValidEmail().0 {
                            showAlert(title: "Error", message: generateLeadCell.emailIdTextField.isValidEmail().1)
            } else {
                if let location = getCurrentLocation() {
                    
                    let lattitude = "\(location.coordinate.latitude)"
                    let longitude = "\(location.coordinate.longitude)"
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
                        
                        if FNSReachability.checkInternetConnectivity() {
                            ServerManager.sharedInstance().generateLead(leadDetails: dict) { (result, data) in
                                self.parseData(data: data, result: result, apiName: "generateLead")
                            }
                            
                        } else {
                            DatabaseManager.shared.insertLeadData(leadDetails: dict)
                            DispatchQueue.main.async {
                                self.hideProgressLoader()
                            }
                            showToast(message: leadSavedOfflineMessage)
                        }
                        
                    } else {
                        if let seriesNumber = self.lead.value(forKey: "SeriesNumber") as? String {
                            dict["SeriesNumber"] = seriesNumber
                        }
                        ServerManager.sharedInstance().updateLead(leadDetails: dict) { (result, data) in
                            
                            self.parseData(data: data, result: result, apiName: "updateLead")
                        }
                    }
                } else {
                    showToast(message: locationNotFound)
                }
            }
            
            
        }
        
    }
    
    func searchLead(button: UIButton) {
        let pincode = searchLeadCell.pincodeTextField.text!
        if (searchLeadCell.pincodeTextField.text?.characters.count)! > 0  &&  pincode.characters.count == 6 {
            ServerManager.sharedInstance().getPincodeDetails(pincode: pincode) { (result, data) in
                self.parseData(data: data, result: result, apiName: "pincode")
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
            self.parseData(data: data, result: result, apiName: "getLeads")
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
            responseCode  = string
        }
        
        if currentElement == "ID" {
            cityID = string
        }
        if currentElement == "Name" || currentElement == "CityName" {
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
        if currentElement == "SwcName" {
            swcName = string
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
        
        if currentElement == "Comments" {
            comments = string
        }
        if currentElement == "Address" {
            address = string
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
            lead.setValue(modelName, forKey: "ModelName")
            lead.setValue(leadDate, forKey: "LeadDate")
            lead.setValue(swcName, forKey: "SwcName")
            lead.setValue(cityName, forKey: "CityName")
            lead.setValue(status, forKey: "Status")
            lead.setValue(address, forKey: "Address")
            lead.setValue(emailId, forKey: "EmailID")
            lead.setValue(alternateMobileNo, forKey: "AlternateMobileNumber")
            lead.setValue(pinCode, forKey: "Pincode")
            lead.setValue(leadSource, forKey: "LeadSource")
            lead.setValue(leadDate, forKey: "SubSource")
            lead.setValue(fixedDemoDate, forKey: "DemoFixedDate")
            lead.setValue(followupDate, forKey: "FollowUpFixedDate")
            lead.setValue(comments, forKey: "Comments")
            // print(lead)
            leads.append(lead)
        }
    }
    
    func editLead(button: UIButton) {
        selectedLead = button.tag
        isGenerateLead = false
        generateLeadAnimation()
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
    
    func parseData(data: Data, result: String, apiName: String) {
        
        DispatchQueue.main.async {
            self.hideProgressLoader()
        }
        if result == requestTimeOutErrorMessage {
            DispatchQueue.main.async {
                self.showToast(message: result)
            }
            
        }  else {
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            let success:Bool = parser.parse()
            if success {
                switch responseCode {
                case "200":
                    DispatchQueue.main.async {
                        if apiName == "cityDetails" {
                            self.generateLeadCell.regionTextField.text = self.region
                        } else if apiName == "cityList" {
                            self.generateLeadCell.cityTextField.data = self.cityList
                        } else if apiName == "productDetails" {
                            if !self.isSearch {
                                self.generateLeadCell.statusTextField.statusData = self.statusArray
                                if self.generateLeadCell.statusTextField.text == "Follow Up" {
                                    self.generateLeadCell.followupDateTextField.isHidden = false
                                } else {
                                    self.generateLeadCell.followupDateTextField.isHidden = true
                                    self.generateLeadCell.followupDateTextField.text = ""
                                }
                                self.generateLeadCell.productNameTextField.data = self.productList
                                self.generateLeadCell.enquiryTextField.statusData = self.sourceArray
                                self.getDetailsApi()
                            }
                           
                        } else if apiName == "generateLead" {
                            self.showAlert(title: "Sucessful", message: "Lead Created Sucessfully")
                        } else if apiName == "updateLead" {
                            self.showAlert(title: "Sucessful", message: leadUpdateMessage)
                        } else if apiName == "getLeads" {
                            if self.leads.count == 0 {
                                self.showToast(message: noLeadMessage)
                            }
                            self.leadTableView.reloadData()
                        } else if apiName == "pincode" {
                            self.getLeads()
                        }
                    }
                    break
                case "400":
                    DispatchQueue.main.async {
                        self.showToast(message: serverErrorMessage)
                    }
                    break
                    
                case "404":
                    
                    DispatchQueue.main.async {
                        if apiName == "getLeads" {
                            self.showToast(message: noLeadMessage)

                        } else if apiName == "pincode" {
                            self.showToast(message: locationNotFoundForPincode)

                        }
                        self.leadTableView.reloadData()
                    }
                    break

                    
                default:
                    break
                }
 
            }
            
        }
    }
    
    @IBAction func searchGenerateLeadAction(_ sender: UIButton) {
        if (searchLeadCell.mobileTextField.text?.characters.count)! > 0 {
            searchLeadMobileNo = searchLeadCell.mobileTextField.text!
            if leads.count > 0 {
                isGenerateLead = true
                self.lead = self.leads[0]
                generateLeadAnimation()
            } else {
                isGenerateLead = true
                generateLeadAnimation()
            }
        } else {
            showAlert(title: "", message: "Please enter Mobile no. and Search")
        }
       
        
    }
}
