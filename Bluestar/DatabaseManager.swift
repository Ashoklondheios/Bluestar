//
//  DatabaseManager.swift
//
//
//  Created by Ashok Londhe on 21/08/17.
//
//

import Foundation
import UIKit
import FMDB

class DatabaseManager: NSObject {
    
    var field_customerName = "customerName"
    var field_mobileNumber = "mobileNumber"
    var field_emailId = "emailId"
    var field_alternateMobileNo = "alternateMobileNo"
    var field_pinCode = "pinCode"
    var field_cityName = "cityName"
    var field_address = "address"
    var field_leadSource = "leadSource"
    var field_productName = "productName"
    var field_modelName = "modelName"
    var field_modelDescription = "modelDescription"
    var field_swcName = "swcName"
    var field_fixedDemoDate = "fixedDemoDate"
    var field_followupDate = "followupDate"
    var field_status = "status"
    let field_comments = "comments"
    let field_roleId = "roleId"
    var field_createdBy = "createdBy"
    let field_longitude = "longitude"
    var field_latitude = "latitude"
    let field_leadRaisedAddress = "leadRaisedAddress"
    
    
    
    static let shared: DatabaseManager = DatabaseManager()
    let databaseFileName = "database.sqlite"
    var pathToDatabase: String!
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createPersonTableQuery = "create table lead(\(field_customerName) text not null, \(field_mobileNumber) text not null, \(field_emailId) text not null, \(field_alternateMobileNo) text,\(field_pinCode) text not null, \(field_cityName) text, \(field_address) text, \(field_leadSource) text, \(field_productName) text, \(field_modelName) text, \(field_swcName) text, \(field_fixedDemoDate) text, \(field_followupDate) text , \(field_status) text, \(field_comments) text, \(field_createdBy) text, \(field_roleId) text, \(field_longitude) text, \(field_latitude) text, \(field_leadRaisedAddress) text)"
                    
                    
                    do {
                        try database.executeUpdate(createPersonTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                    }
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func insertLeadData(leadDetails: [String: String]) {
        if openDatabase() {
            var query = ""
            if let customerName = leadDetails["CustomerName"] , let emailID = leadDetails["EmailID"] , let mobileNumber = leadDetails["MobileNumber"] , let alternateNumber = leadDetails["AlternateNumber"] , let pincode = leadDetails["Pincode"] , let cityName = leadDetails["CityName"] , let address = leadDetails["Address"] , let leadSource = leadDetails["LeadSource"] , let productName = leadDetails["ProductName"] , let modelName = leadDetails["ModelName"] , let swcName = leadDetails["SwcName"] , let demoFixedDate = leadDetails["DemoFixedDate"] , let followUpDate = leadDetails["FollowUpDate"] , let leadStatus = leadDetails["LeadStatus"] , let comments = leadDetails["Comments"] , let roleID = leadDetails["RoleID"] , let createdBy = leadDetails["CreatedBy"] , let longitude = leadDetails["Longitude"] , let latitude = leadDetails["Latitude"] , let leadRaisedAddress = leadDetails["LeadRaisedAddress"] {
                
                query += "insert into lead (\(field_customerName),\(field_mobileNumber),\(field_emailId),\(field_alternateMobileNo),\(field_pinCode),\(field_cityName),\(field_address),\(field_leadSource),\(field_productName),\(field_modelName),\(field_fixedDemoDate),\(field_followupDate),\(field_status),\(field_comments),\(field_roleId),\(field_createdBy),\(field_longitude),\(field_latitude),\(field_leadRaisedAddress),\(field_swcName)) values ('\(customerName)','\(mobileNumber)','\(emailID)','\(alternateNumber)','\(pincode)', '\(cityName)','\(address)','\(leadSource)','\(productName)','\(modelName)','\(demoFixedDate)','\(followUpDate)','\(leadStatus)','\(comments)' , '\(roleID)','\(createdBy)','\(longitude)','\(latitude)','\(leadRaisedAddress)', '\(swcName)');"
                
                if !database.executeStatements(query) {
                    
                } else {
                    
                }
                database.close()
            }
        }
    }
    
    
    func loadData() {
        if openDatabase() {
           
            let query = "select * from lead"
            do {
                let results = try database.executeQuery(query, values: nil)
                var count = 0
                while results.next() {
                    count =  count + 1
                    let customerName = results.string(forColumn: field_customerName)
                    let mobileNumber = results.string(forColumn: field_mobileNumber)
                    let email_id = results.string(forColumn: field_emailId)
                    let alternateNumber = results.string(forColumn: field_alternateMobileNo)
                    let pincode = results.string(forColumn: field_pinCode)
                    let cityName = results.string(forColumn: field_cityName)
                    let address = results.string(forColumn: field_address)
                    let leadSource = results.string(forColumn: field_leadSource)
                    let productName = results.string(forColumn: field_productName)
                    let modelName = results.string(forColumn: field_modelName)
                    let swcName = results.string(forColumn: field_swcName)
                    let demoFixedDate = results.string(forColumn: field_fixedDemoDate)
                    let followupDate = results.string(forColumn: field_followupDate)
                    let leadStatus = results.string(forColumn: field_status)
                    let comments = results.string(forColumn: field_comments)
                    let roleId = results.string(forColumn: field_roleId)
                    let createdBy = results.string(forColumn: field_createdBy)
                    let longitude = results.string(forColumn: field_longitude)
                    let lattitude = results.string(forColumn: field_latitude)
                    let leadRaisedAddress = results.string(forColumn: field_leadRaisedAddress)
                    
                    
                    let dict: [String: String] = [
                        "CustomerName": customerName!,
                        "EmailID": email_id!,
                        "MobileNumber": mobileNumber!,
                        "AlternateNumber": alternateNumber!,
                        "Pincode": pincode!,
                        "CityName": cityName!,
                        "Address": address!,
                        "LeadSource": leadSource!,
                        
                        "ProductName": productName!,
                        "ModelName": modelName!,
                        "SwcName": swcName!,
                        "DemoFixedDate": demoFixedDate!,
                        "FollowUpDate":followupDate!,
                        "LeadStatus":leadStatus!,
                        "Comments": comments!,
                        "RoleID": roleId!,
                        "CreatedBy": createdBy!,
                        "Longitude": longitude!,
                        "Latitude":  lattitude!,
                        "LeadRaisedAddress":  leadRaisedAddress!
                    ]
                    
                    ServerManager.sharedInstance().generateLead(leadDetails:dict) { (result, data) in
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.Name("LeadSavedNotification"), object: nil)
                        }
                    }
                }
                
                if count > 0 {
                    let  deleteQuery = "delete from lead"
                    let isDeleted = database.executeStatements(deleteQuery)
                    if isDeleted {
                        print("Data is deleted from database...!!!")
                    }
                }
            } catch {
                
            }
        }
        database.close()
        
        
    }    
}
