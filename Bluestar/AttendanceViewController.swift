//
//  AttendanceViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 22/07/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import AddressBookUI

class AttendanceViewController: BaseViewController , XMLParserDelegate {

    //let locationManager = CLLocationManager()
    var curentElement = ""
    var userDetails = ServerManager.sharedInstance().userDetailsDict

    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   locationManager.delegate = self
     //   locationManager.desiredAccuracy = kCLLocationAccuracyBest
      //  locationManager.startUpdatingLocation()
        self.title = "Blue Star"
                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePlaceMark()
        self.navigationItem.hidesBackButton = true
        
    }
    
    func updatePlaceMark() {
        if let _ = self.getCurrentLocation(){
            self.getPlacemark()
        }
    }
    
    // MARK: - Mark attendence...
    @IBAction func presentButtonAction(_ sender: UIButton) {
        self.getPlacemark()
        
        if(CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied) {
            // show the map
            
            if let currentLocation = self.getCurrentLocation(), let userId = userDetails.value(forKey: "ID") as? String {
                
                var address = ""
                if let placemark = self.placemark {
                    if let _ = placemark.locality {
                        address = ABCreateStringWithAddressDictionary(placemark.addressDictionary!, false)
                        print("\n\(address)")
                    }
                }
                showProgressLoader()
                ServerManager.sharedInstance().getAttendance(userID: userId, in_out_flag: true, ipAddress: "10.236.125.14", lattitude: "\(currentLocation.coordinate.latitude)", longitude:  "\(currentLocation.coordinate.longitude)", address: address) { (result, data) in
                    print(result)
                    DispatchQueue.main.async {
                        self.hideProgressLoader()
                    }                    
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    let success:Bool = parser.parse()
                    
                    if success {
                        if ServerManager.sharedInstance().getAttendenceDict.count > 0 {
                            print(ServerManager.sharedInstance().getAttendenceDict)
                            let userDetailsDict = ServerManager.sharedInstance().getAttendenceDict
                            let responseCode = userDetailsDict.value(forKey: "ResponseCode") as! String
                            switch  responseCode {
                            case "200":
                                DispatchQueue.main.async {
                                    self.showToast(message: "Attendence Marked")
                                UserDefaults.standard.set(true, forKey: "isAttendenceMarked")
                                UserDefaults.standard.set(Date(), forKey: "CurrentDate")
                                    self.performSegue(withIdentifier: "assignedLeadSegue", sender: nil)
                                    
                                }
                                break
                                
                            case "404", "402", "400":
                                DispatchQueue.main.async {
                                    self.showToast(message: "Location not found. Please try again...")
                                }
                                break
                            default:
                                break
                                
                            }
                            
                        } else {
                            
                        }
                        
                    }

                }

            } else {
                showToast(message: "Please enable GPS... Location not found...")
            }

        } else {
            // show error
            showToast(message: "Please enable GPS... Location not found...")
        }
        
    }
    
    func markAttendance() {
    
    
    }
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.coordinate.latitude ?? "")
        print(manager.location?.coordinate.longitude ?? "")

    }
    override func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print(manager.location?.coordinate.latitude ?? "")
        print(manager.location?.coordinate.longitude ?? "")

    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        curentElement =  elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        let getAttendenceDict: NSMutableDictionary = ServerManager.sharedInstance().getAttendenceDict
        
        if curentElement == "ResponseCode" {
            getAttendenceDict.setValue(string, forKey: "ResponseCode")
        }else if curentElement == "DateTime" {
            getAttendenceDict.setValue(string, forKey: "DateTime")
        }
        
    }

    

}
