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

    
    var currentElement = ""
    var userDetails = ServerManager.sharedInstance().userDetailsDict

    @IBOutlet weak var markAttendenceButtion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.title = "Blue Star"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updatePlaceMark()
        if UserDefaults.standard.bool(forKey: "isFromPunchOut") {
            markAttendenceButtion.setTitle("Punch Out", for: .normal)
        } else {
            markAttendenceButtion.setTitle("Present", for: .normal)
        }

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
                    }
                }
                var in_out_flag = true
                 if UserDefaults.standard.bool(forKey: "isFromPunchOut") {
                    in_out_flag = false
                }
                
                showProgressLoader()
                ServerManager.sharedInstance().getAttendance(userID: userId, in_out_flag: in_out_flag, ipAddress: "10.236.125.14", lattitude: "\(currentLocation.coordinate.latitude)", longitude:  "\(currentLocation.coordinate.longitude)", address: address) { (result, data) in
                    
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    let success:Bool = parser.parse()
                    DispatchQueue.main.async {
                        self.hideProgressLoader()
                    }
                    
                    if success {
                        if ServerManager.sharedInstance().getAttendenceDict.count > 0 {
                            let userDetailsDict = ServerManager.sharedInstance().getAttendenceDict
                            let responseCode = userDetailsDict.value(forKey: "ResponseCode") as! String
                            switch  responseCode {
                            case "200":
                                DispatchQueue.main.async {
                                    if UserDefaults.standard.bool(forKey: "isFromPunchOut") {
                                        self.showToast(message: "Punch Out Sucessfully.")
                                        UserDefaults.standard.set(true, forKey: "isPunchOut")
                                    } else {
                                        self.showToast(message: "Attendence Marked.")
                                    }
                                UserDefaults.standard.set(true, forKey: "isAttendenceMarked")
                                UserDefaults.standard.set(Date(), forKey: "CurrentDate")
                                    let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
                                    DispatchQueue.main.asyncAfter(deadline: when) {
                                       self.performSegue(withIdentifier: "leadSegue", sender: nil)
                                    }
                                
                                    
                                }
                                break
                                
                            case "404", "402", "400":
                                DispatchQueue.main.async {
                                    self.showToast(message: locationNotFound)
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
                DispatchQueue.main.async {
                    self.showToast(message: enableGPS)
                }

            }

        } else {
            // show error
            DispatchQueue.main.async {
                self.showToast(message: enableGPS)
            }

        }
        
    }
    
    func markAttendance() {
    
    
    }
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    override func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement =  elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        let getAttendenceDict: NSMutableDictionary = ServerManager.sharedInstance().getAttendenceDict
        
        if currentElement == "ResponseCode" {
            getAttendenceDict.setValue(string, forKey: "ResponseCode")
        }else if currentElement == "DateTime" {
            getAttendenceDict.setValue(string, forKey: "DateTime")
        }
        
    }

    

}
