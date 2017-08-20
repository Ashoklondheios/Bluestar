//
//  ServerManager.swift
//  Bluestar
//
//  Created by Ashok Londhe on 20/07/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import Foundation
import UIKit

class ServerManager {
    
    // MARK:- API - User Details
    
    var userDetailsDict = NSMutableDictionary()
    var getAttendenceDict = NSMutableDictionary()
    var leadDictionary = NSMutableDictionary()
    
    class func sharedInstance() -> ServerManager {
        struct Static {
            static let sharedInstance = ServerManager()
        }
        return Static.sharedInstance
    }
    
    func getUserDetails(userName: String, completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        if FNSReachability.checkInternetConnectivity() {
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><getUserDetails xmlns='http://tempuri.org/'><userName>\(userName)</userName></getUserDetails></soap:Body></soap:Envelope>"
            self.postApiCall(soapMessage: soapMessage) { (result, data) in
                completion(result, data)
            }
            
        }
    }
    
    
    func getAttendance(userID: String, in_out_flag: Bool, ipAddress: String, lattitude: String , longitude: String , address: String, completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><setAttendance xmlns='http://tempuri.org/'><userID>\(userID)</userID><in_out_flag>1</in_out_flag><ipAddress>\(ipAddress)</ipAddress><address>\(address)</address><latitude>\(lattitude)</latitude><longitude>\(longitude)</longitude></setAttendance></soap:Body></soap:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    func generateLead(leadDetails: [String: String], completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        
        if let customerName = leadDetails["CustomerName"] as? String, let emailID = leadDetails["EmailID"] as? String, let mobileNumber = leadDetails["MobileNumber"] as? String, let alternateNumber = leadDetails["AlternateNumber"] as? String, let pincode = leadDetails["Pincode"] as? String, let cityName = leadDetails["CityName"] as? String, let address = leadDetails["Address"] as? String, let leadSource = leadDetails["LeadSource"] as? String, let productName = leadDetails["ProductName"] as? String, let modelName = leadDetails["ModelName"] as? String, let swcName = leadDetails["SwcName"] as? String, let demoFixedDate = leadDetails["DemoFixedDate"] as? String, let followUpDate = leadDetails["FollowUpDate"] as? String, let leadStatus = leadDetails["LeadStatus"] as? String, let comments = leadDetails["Comments"] as? String, let roleID = leadDetails["RoleID"] as? String, let createBy = leadDetails["CreatedBy"] as? String, let longitude = leadDetails["Longitude"] as? String, let Latitude = leadDetails["Latitude"] as? String, let leadRaisedAddress = leadDetails["LeadRaisedAddress"] {
            let leadSubSource = ""
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><createLead xmlns='http://tempuri.org/'><CustomerName>\(customerName)</CustomerName><EmailID>\(emailID)</EmailID><MobileNumber>\(mobileNumber)</MobileNumber><AlternateNumber>\(alternateNumber)</AlternateNumber><Pincode>\(pincode)</Pincode><CityName>\(cityName)</CityName><Address>\(address)</Address><LeadSource>\(leadSource)</LeadSource><LeadSubSource>\(leadSubSource)</LeadSubSource><ProductName>\(productName)</ProductName><ModelName>\(modelName)</ModelName><SwcName >\(swcName)</SwcName><DemoFixedDate>\(demoFixedDate)</DemoFixedDate><FollowUpDate>\(followUpDate)</FollowUpDate><LeadStatus>\(leadStatus)</LeadStatus><Comments>\(comments)</Comments><RoleID>\(roleID)</RoleID><CreatedBy>\(createBy)</CreatedBy><Longitude>\(longitude)</Longitude><Latitude>\(Latitude)</Latitude><LeadRaisedAddress>\(leadRaisedAddress)</LeadRaisedAddress></createLead></soap:Body></soap:Envelope>"
            self.postApiCall(soapMessage: soapMessage) { (result, data) in
                completion(result, data)
            }
            
        }
    }
    
    
    
    func getAssigned(userID: String, completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><getAssignedLeads xmlns='http://tempuri.org/'><UserID>\(userID)</UserID></getAssignedLeads></soap:Body></soap:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    
    func getCityList(completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        
        let soapMessage = "<!--?xml version='1.0' encoding= 'UTF-8' ?--><v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://schemas.xmlsoap.org/soap/encoding/' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><getCityNames xmlns='http://tempuri.org/' id='o0' c:root='1'><MaxCityID>0</MaxCityID></getCityNames></v:Body></v:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    
    func getCityDetails(cityName: String, completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body> <getCityDetails xmlns='http://tempuri.org/'><CityName>\(cityName)</CityName></getCityDetails></soap:Body></soap:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    
    func getProductDetails(completion: @escaping (_ result: String, _ data: Data) -> Void) {
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <getProductDetails xmlns='http://tempuri.org/'/></soap:Body></soap:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    func getLeads(leadId: String, customerName: String, phoneNumber: String,  pinCode: String, productName: String, status: String ,completion: @escaping (_ result: String, _ data: Data) -> Void) {
        
        if FNSReachability.checkInternetConnectivity() {
            let soapMessage = "<!--?xml version='1.0' encoding= 'UTF-8' ?--><v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://schemas.xmlsoap.org/soap/encoding/' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><getLeads xmlns='http://tempuri.org/'><SeriesNumber>\(leadId)</SeriesNumber><CustomerName>\(customerName)</CustomerName><PhoneNumber>\(phoneNumber)</PhoneNumber><Pincode>\(pinCode)</Pincode><ProductName>\(productName)</ProductName><Status>\(status)</Status></getLeads></v:Body></v:Envelope>"
            self.postApiCall(soapMessage: soapMessage) { (result, data) in
                completion(result, data)
            }
            
        }
    }
    
    
    func getPincodeDetails(pincode: String, completion: @escaping (_ result: String, _ data: Data) -> Void) {
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><getPincodeDetails xmlns='http://tempuri.org/'><Pincode>\(pincode)</Pincode></getPincodeDetails></soap:Body></soap:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    func getLeadHistory(seriesNumber: String, completion: @escaping (_ result: String, _ data: Data) -> Void) {
        
        let soapMessage = "<!--?xml version='1.0' encoding= 'UTF-8' ?--><v:Envelope xmlns:i='http://www.w3.org/2001/XMLSchema-instance' xmlns:d='http://www.w3.org/2001/XMLSchema' xmlns:c='http://schemas.xmlsoap.org/soap/encoding/' xmlns:v='http://schemas.xmlsoap.org/soap/envelope/'><v:Header /><v:Body><getLeadHistory xmlns='http://tempuri.org/' id='o0' c:root='1'><SeriesNumber>\(seriesNumber)</SeriesNumber ></getLeadHistory></v:Body></v:Envelope>"
        self.postApiCall(soapMessage: soapMessage) { (result, data) in
            completion(result, data)
        }
        
    }
    
    
    func updateLead(leadDetails: [String: String], completion: @escaping (_ result: String, _ data: Data) -> Void)  {
        
        
        if let seriesNumber = leadDetails["SeriesNumber"], let customerName = leadDetails["CustomerName"], let emailID = leadDetails["EmailID"], let mobileNumber = leadDetails["MobileNumber"], let alternateNumber = leadDetails["AlternateNumber"], let pincode = leadDetails["Pincode"], let cityName = leadDetails["CityName"], let address = leadDetails["Address"] , let leadSource = leadDetails["LeadSource"] , let productName = leadDetails["ProductName"] , let modelName = leadDetails["ModelName"] , let swcName = leadDetails["SwcName"] , var demoFixedDate = leadDetails["DemoFixedDate"] , let leadStatus = leadDetails["LeadStatus"] , let comments = leadDetails["Comments"],  let createBy = leadDetails["CreatedBy"] , let longitude = leadDetails["Longitude"] , let Latitude = leadDetails["Latitude"] , let leadRaisedAddress = leadDetails["LeadRaisedAddress"] {
            
            var followUpDate = ""
            if let followUp = leadDetails["FollowUpDate"] {
                followUpDate = followUp
                let date = followUpDate.dateFromString()
                followUpDate = followUpDate.dateToString(dateTime: date)

            }
            
            let date = demoFixedDate.dateFromString()
            demoFixedDate = demoFixedDate.dateToString(dateTime: date)
            
            let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:tem='http://tempuri.org/'><soapenv:Header/><soapenv:Body><updateLead xmlns='http://tempuri.org/'><SeriesNumber>\(seriesNumber)</SeriesNumber><CustomerName>\(customerName)</CustomerName><EmailID>\(emailID)</EmailID><MobileNumber>\(mobileNumber)</MobileNumber><AlternateNumber>\(alternateNumber)</AlternateNumber><Pincode>\(pincode)</Pincode><CityName>\(cityName)</CityName><Address>\(address)</Address><LeadSource>\(leadSource)</LeadSource><LeadSubSource></LeadSubSource><ProductName>\(productName)</ProductName><SwcName>\(swcName)</SwcName><ModelName>\(modelName)</ModelName><DemoFixedDate>\(demoFixedDate)</DemoFixedDate><FollowUpDate>\(followUpDate)</FollowUpDate><LeadStatus>\(leadStatus)</LeadStatus><Comments>\(comments)</Comments><UpdatedBy>\(createBy)</UpdatedBy><Longitude>\(longitude)</Longitude><Latitude>\(Latitude)</Latitude><LeadRaisedAddress>\(leadRaisedAddress)</LeadRaisedAddress></updateLead></soapenv:Body></soapenv:Envelope>"
            self.postApiCall(soapMessage: soapMessage) { (result, data) in
                completion(result, data)
            }
        }
    }
    
    func postApiCall(soapMessage: String, completion: @escaping (_ result: String, _ data: Data) -> Void) {
        if FNSReachability.checkInternetConnectivity() {
            
            if let url = NSURL(string: base_Url) {
                let theRequest = NSMutableURLRequest(url: url as URL)
                theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
                theRequest.addValue((soapMessage), forHTTPHeaderField: "Content-Length")
                theRequest.httpMethod = "POST"
                theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
                URLSession.shared.dataTask(with: theRequest as URLRequest) { (data, response, error) in
                    if error == nil {
                        if let data = data, let result = String(data: data, encoding: String.Encoding.utf8) {
                            
                            completion(result, data)
                        }
                    } else {
                        completion("Request time out error...!!!", NSData() as Data)
                    }
                    
                    }.resume()
            }
            
        } else {
            NotificationCenter.default.post(name: Notification.Name("InternetConnecionLostNotification"), object: nil)
        }
    }
    
}
