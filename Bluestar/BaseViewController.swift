//
//  BaseViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 10/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation
import AddressBook

class BaseViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentLocation = CLLocation()
    let locationManager = CLLocationManager()
    let activityViewLayerCornerRadius = 05
    let activityViewBackgroundAlpha = 0.5
    let activityViewColorAlpha = 1.0
    let activityViewColorRed = 1.0
    let activityViewColorGreen = 1.0
    let activityViewColorBlue = 1.0
    var mainArray: NSArray = []
    var filerArray: NSArray = []
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        applyStyleForActivityIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.noNetworkConnection), name: NSNotification.Name(rawValue: "InternetConnecionLostNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func addCustomNavigationButton() {
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        let backButtonImage = UIImage(named: "backButton")
        let customBarButton = UIBarButtonItem(image: backButtonImage,
                                              style: .plain,
                                              target: self,
                                              action: #selector(BaseViewController.goToParentViewController))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.setLeftBarButton(customBarButton, animated: true)
        
        
    }
    
    func goToParentViewController() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func noNetworkConnection()  {
        DispatchQueue.main.async {
            self.hideProgressLoader()
            self.showToast(message: noNetworkConnectionMessage)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location?.coordinate.latitude ?? "")
        print(manager.location?.coordinate.longitude ?? "")
        currentLocation = manager.location!
        
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print(manager.location?.coordinate.latitude ?? "")
        print(manager.location?.coordinate.longitude ?? "")
        currentLocation = manager.location!

    }

    func getAddressForLatLng(latitude: String, longitude: String) {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        let apikey = "12345"
        let url = NSURL(string: "\(baseUrl)latlng=\(latitude),\(longitude)&key=\(apikey)")
        let data = NSData(contentsOf: url as! URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
//            if let address = result[0]["address_components"] as? NSArray {
//                let number = address[0]["short_name"] as! String
//                let street = address[1]["short_name"] as! String
//                let city = address[2]["short_name"] as! String
//                let state = address[4]["short_name"] as! String
//                let zip = address[6]["short_name"] as! String
//                print("\n\(number) \(street), \(city), \(state) \(zip)")
//            }
        }
    }
    
    func getPlacemark() {
        
        if let location = getCurrentLocation() {
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
                print((placeMarks?[0])!)
                self.placemark = (placeMarks?[0])!
            })
        }
    }
    func getCurrentLocation() -> CLLocation? {
        
        if(CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied) {

            return locationManager.location
        }
        return nil
    }
    
    func applyStyleForActivityIndicator() {
        
        activityView.layer.cornerRadius = CGFloat(activityViewLayerCornerRadius)
        // activityView.center = self.view.center
            activityView.center = CGPoint(x: self.view.frame.width / 2.0 , y: self.view.frame.size.height / 2.0)
        activityView.backgroundColor = UIColor(white: 0.0, alpha: CGFloat(activityViewBackgroundAlpha))
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityView.color = UIColor(red:CGFloat(activityViewColorRed),green:CGFloat(activityViewColorGreen),blue:CGFloat(activityViewColorBlue),alpha:CGFloat(activityViewColorAlpha))
        activityView.hidesWhenStopped = true
    }
    
    func showProgressLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.activityView.startAnimating()
            self.view.addSubview(self.activityView)

        }
    }
    
    func hideProgressLoader() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.activityView.stopAnimating()
            self.activityView.removeFromSuperview()

        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }



}
