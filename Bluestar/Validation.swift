//
//  Validation.swift
//  Bluestar
//
//  Created by Ashok Londhe on 16/07/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import Foundation
import UIKit


extension BSTextField {

    func isValidEmail() -> (Bool, String) {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self.text)
        if(result == true) {
            return(result, "")
        }
        return (result, invalidEmail)
    }
    
    func validatePhoneNumber(value: String) -> (Bool, String) {
        
        let phoneRegex = "^\\d {3}-\\d {3}-\\d {4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result =  phoneTest.evaluate(with: value)
        if(result == true) {
            return(result, "")
        }
        return (result, inValidPhoneNumber)
    }

    
    // MARK: Empty field validations.
    
    func isEmpty(str: String) -> (Bool, String) {
        let trimmedstr: String = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedstr.isEmpty {
            return (true, blankIdAndPassword)
        }
        return (false, "")
    }
}
