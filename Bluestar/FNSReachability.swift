//
//  FNSReachability.swift
//  FNS-Health
//
//  Created by ashok.londhe on 19/12/16.
//  Copyright © 2016 v2solutions. All rights reserved.
//

import Foundation
import SystemConfiguration

public class FNSReachability {
    
    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
       
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
            
        }) else {
            
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
        
    }
    
    
    class func checkInternetConnectivity() -> Bool {
        
        if FNSReachability.isConnectedToNetwork() == true {
//            print("Internet connection OK")
            return true
        } else {
            print("Internet connection FAILED")
            NotificationCenter.default.post(name: Notification.Name("InternetConnecionLostNotification"), object: nil)
            return false
            
        }
        
    }
    
}