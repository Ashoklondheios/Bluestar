//
//  DataManager.swift
//  Bluestar
//
//  Created by Ashok Londhe on 30/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    var productNameList = [NSMutableDictionary]()
    var statusArray = [String]()
    var leadSourceArray = [String]()
    
    var selectedProductName = ""
    var pincode = ""

    
    // MARK: Created shared Instance.
    
    class func sharedInstance() -> DataManager {
        struct Static {
            static let sharedInstance = DataManager()
        }
        return Static.sharedInstance
    }

    
    
    
}
