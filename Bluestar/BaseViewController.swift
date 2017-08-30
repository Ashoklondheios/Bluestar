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
    let activityViewBackgroundAlpha = 0.7
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
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.offlineLeadSaved), name: NSNotification.Name(rawValue: "LeadSavedNotification"), object: nil)
        if FNSReachability.checkInternetConnectivity() {
            DatabaseManager.shared.loadData()
        } else {
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FNSReachability.checkInternetConnectivity() {
            DatabaseManager.shared.loadData()
        } else {
          
        }
    }

    func offlineLeadSaved() {
        showToast(message: leadUploadMessage)
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
        currentLocation = manager.location!
        
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        currentLocation = manager.location!

    }
    
    func getPlacemark() {
        
        if let location = getCurrentLocation() {
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
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
