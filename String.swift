//
//  String.swift
//  Bluestar
//
//  Created by Ashok Londhe on 20/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import Foundation

extension String {
    func dateFromString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone.current
        var date = dateFormatter.date(from: self)
        if date == nil {
            date = Date()
        }
        return date!
    }
    
    func dateFromString1() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        var date = dateFormatter.date(from: self)
        if date == nil {
            date = Date()
        }
        return date!
    }


    func dateToString(dateTime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy H:mm a"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: dateTime)
        return date
    }

}
