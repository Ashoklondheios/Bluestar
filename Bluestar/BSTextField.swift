//
//  BSTextField.swift
//  Bluestar
//
//  Created by Ashok Londhe on 15/07/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit


let textFieldBorderWidth = 1.0
let textFieldCornerRadius = 2.0
let textFieldDefaultText = "Username"
let textFieldDefaultEmailText = "Email"
let textFieldDefaultPasswordText = "Password"
let textFieldDefaultPhoneText = "Phone Number"


enum BSTextFieldStyle: Int {
    case Default
    case Email
    case Password
    case PhoneNumber
    case DatePicker
    case UserName
    case Picker
}

enum BSTextFieldBorder: Int {
    case Left
    case Right
    case Top
    case Bottom
    case All
    case None
}

enum BSTextFieldStatus: Int {
    case Default
    case Error
}

class BSTextField: UITextField, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    var datePickerView: UIDatePicker?
    
    var status: BSTextFieldStatus = .Default
    var style: BSTextFieldStyle = .Default
    var textFieldBorderStyle: BSTextFieldBorder = .None
    var borderColors = [AnyObject]()
    var placeHolderString = ""
    var inputMaskString: String?
    var textFieldImage: UIImage!
    var datePicker: UIDatePicker!
    var date: NSDate?
    var rightImageName: String?
    var pickerView = UIPickerView()
    
    var pickerData = [String]() {
        didSet {
            updateSelf()
            updateStyle()
            // updateSelf()
        }
    }
    
    var data  = [NSMutableDictionary]() {
        didSet {
            updateSelf()
            updateStyle()
            // updateSelf()
        }
    }
    
    var statusData  = [String]() {
        didSet {
            updateSelf()
            updateStyle()
            //  updateSelf()
        }
    }
    
    
    func commonInit() {
        
        self.delegate = self
        datePickerView = UIDatePicker()
        self.borderColors = [UIColor.lightGray, UIColor.red]
        self.rightViewMode = .always
        self.autocorrectionType = .no
        date = NSDate()
        self.textFieldBorderStyle = .Bottom
        self.font = UIFont.systemFont(ofSize: 16)
        //self.place
        updateSelf()
        self.updateStyle()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func setStatus(status: BSTextFieldStatus) {
        self.commonInit()
        self.status = status
    }
    
    func setStyle(style: BSTextFieldStyle, border: BSTextFieldBorder) {
        
        if style != style {
            self.style = style
            self.textFieldBorderStyle = border
        }
        self.commonInit()
        self.style = style
        self.textFieldBorderStyle = border
        updateStyle()
    }
    
    
    func setStyle(_ style: BSTextFieldStyle) {
        if style != style {
            self.style = style
        }
        self.commonInit()
        self.style = style
        self.textFieldBorderStyle = .Bottom
        updateStyle()
        
    }
    
    func setBorderStyle(borderStyle: BSTextFieldBorder) {
        self.textFieldBorderStyle = borderStyle
    }
    
    
    func updateSelf() {
        self.layer.borderColor = self.borderColors[self.status.rawValue].cgColor
        self.layer.layoutIfNeeded()
        self.layer.masksToBounds = true
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    func updateStyle() {
        updateSelf()
        if self.textFieldBorderStyle != .None {
            self.delegate = self
            self.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.gray, withBorderWidth: 1)
            self.layoutIfNeeded()
        }
        else {
            self.borderStyle = .none
        }
        
        switch self.style {
            
        case .DatePicker:
            self.delegate = self
            // self.text = ""
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 40, height: 40))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            
            break
        case .Picker:
            self.delegate = self
            // self.text = ""
            pickerView.delegate = self
            pickerView.dataSource = self
            
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 40, height: 40))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            
            
            break
        case .UserName:
            self.delegate = self
            // self.text = ""
            self.keyboardType = .default
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 20, height: 20))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            break
        case .Email:
            self.delegate = self
            self.backgroundColor = UIColor.white
            self.keyboardType = .emailAddress
            self.setAttributedText(defaultPlaceholder: textFieldDefaultEmailText)
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 20, height: 20))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            
            break
            
        case .Password:
            self.delegate = self
            self.keyboardType = .default
            self.textFieldImage = UIImage(named: "ic_key")
            let rightIcon = UIImageView(image: self.textFieldImage)
            let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 20, height: 20))
            rightIcon.frame = rect
            self.rightViewMode = .always
            self.rightView = rightIcon
            break
            
        case .Default:
            self.keyboardType = .default
            self.delegate = self
            
            if let rightSideImageName = rightImageName {
                self.textFieldImage = UIImage(named: rightSideImageName)
                let rightIcon = UIImageView(image: self.textFieldImage)
                let rect = CGRect(origin: CGPoint(x: textFieldImage.size.width, y: 0), size: CGSize(width: 20, height: 20))
                rightIcon.frame = rect
                self.rightViewMode = .always
                self.rightView = rightIcon
                
            }
            
            break
            
        case .PhoneNumber:
            self.delegate = self
            self.backgroundColor = UIColor.white
            self.keyboardType = .phonePad
            break
            
        }
        
        self.layer.layoutIfNeeded()
        self.layer.masksToBounds = true
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    func setAttributedText(defaultPlaceholder: String) {
        if self.placeHolderString.isEmpty || self.placeHolderString == "" {
            self.attributedPlaceholder = NSAttributedString(string: defaultPlaceholder, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        }
        else {
            self.attributedPlaceholder = NSAttributedString(string: self.placeHolderString, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        }
    }
    
    func setBorderToTextField(vBorder: BSTextFieldBorder, withBorderColor borderColor: UIColor, withBorderWidth borderWidth: CGFloat) {
        let border = CALayer()
        var rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
        switch vBorder {
        case .Left:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: borderWidth, height: self.frame.size.height))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .Right:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: self.frame.size.width - borderWidth, y: 0), size: CGSize(width: borderWidth, height: self.frame.size.height))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .Top:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.size.width, height: borderWidth))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .Bottom:
            border.backgroundColor = borderColor.cgColor
            rect = CGRect(origin: CGPoint(x: 0, y: self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: 2))
            border.frame = rect
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
        case .All:
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            break
            
        case .None:
            self.borderStyle = .none
            break
            
        }
    }
    
    func formatInput(aTextField: UITextField, aString: String, aRange: NSRange) {
        // Copying the contents of UITextField to an variable to add new chars later
        let value = aTextField.text
        var formattedValue = value
        // Make sure to retrieve the newly entered char on UITextField
        // aRange.length = 1
        let myNSRange = NSRange(location: aRange.location, length: 1)
        // var mask  = inputMaskString.substring(with: myNSRange<String.Index>)
        let index1 = inputMaskString?.index((inputMaskString?.endIndex)!, offsetBy: myNSRange.length)
        
        let mask = inputMaskString?.substring(to: index1!)
        // Checking if there's a char mask at current position of cursor
        
        if mask != nil {
            let regex = "[0-9]*"
            let regextest = NSPredicate(format: "SELF MATCHES %@", regex)
            // Checking if the character at this position isn't a digit
            if !regextest.evaluate(with: mask) {
                // If the character at current position is a special char this char must be appended to the user entered text
                formattedValue = formattedValue! + mask!
            }
            if aRange.location + 1 < (self.inputMaskString?.characters.count)! {
                let range = NSRange(location: aRange.location + 1, length: 1)
                let index1 = inputMaskString?.index((inputMaskString?.endIndex)!, offsetBy: range.length)
                let mask = inputMaskString?.substring(to: index1!)
                if mask == " " {
                    formattedValue = formattedValue! + mask!
                }
            }
        }
        
        // Adding the user entered character
        formattedValue = formattedValue! + aString
        // Refreshing UITextField value
        aTextField.text = formattedValue
    }
    
    func setText(string: String, For aTextField: UITextField) {
        aTextField.text = aTextField.text! + string
    }
    
    
    func convertDateFromstring(textField: String, dateFormatter: DateFormatter) -> NSDate {
        let regex = try! NSRegularExpression(pattern: " / ", options: NSRegularExpression.Options.caseInsensitive)
        // Replace the matches
        let modifiedString = regex.stringByReplacingMatches(in: textField, options: [], range: NSMakeRange(0, textField.characters.count), withTemplate: "/")
        let date = dateFormatter.date(from: modifiedString)!
        return date as NSDate
    }
    
    func addDatePickerToTextField() {
        datePickerView?.datePickerMode = .date
        datePickerView?.minimumDate = Date()
        self.inputView = datePickerView
        datePickerView?.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
    }
    
    func handleDatePicker(sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        date = (sender as! UIDatePicker).date as NSDate!
    }
    
    func setDateFormat(selectDate: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let strDate = dateFormatter.string(from: selectDate as Date)
        return strDate
    }
    
    func addButtonToPickerTextField() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputView = datePickerView
        self.inputAccessoryView = toolBar
    }
    
    func addButtonToPickerViewTextField() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelDatePicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.inputView = pickerView
        self.inputAccessoryView = toolBar
    }
    
    func donePicker() {
        if self.style == .DatePicker {
            if (self.text?.characters.count)! > 1 {
                self.text = self.setDateFormat(selectDate: date!)
            }
            else {
                self.text = self.setDateFormat(selectDate: date!)
            }
        }
        self.resignFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ValueSelectedNotification"), object: nil)
    }
    
    func cancelDatePicker() {
        if self.style == .DatePicker {
            if (self.text?.characters.count)! > 1 {
            }
            else {
                self.text = ""
            }
        }
        self.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor(red: (0.0/255.0), green: (122.0/255.0), blue: (255.0/255.0), alpha: 1), withBorderWidth: 1.0)
        // textField.layer.borderColor = UIColor.blue.cgColor
        if self.style == .DatePicker {
            self.addDatePickerToTextField()
            self.addButtonToPickerTextField()
        }
        
        if self.style == .Picker {
            
            if self.tag == 101 {
                self.statusData = DataManager.sharedInstance().leadSourceArray
            }
            
            if self.tag == 102 {
                self.data = DataManager.sharedInstance().productNameList
                pickerView.delegate = self
                pickerView.dataSource = self
            }
            
            if self.tag == 105 {
                self.statusData = DataManager.sharedInstance().statusArray
            }
            self.inputView = pickerView
            self.addButtonToPickerViewTextField()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.style == .Password {
            return true
        } else if self.tag == 106 {
            let text = self.text?.appending(string)
            if text?.characters.count == 6 {
            DataManager.sharedInstance().pincode = text!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PincodeEnteredNotification"), object: nil)
            }
            return true
        }else {
            if self.text?.characters.count == 0 || range.location == 0 {
                if string.characters.count > 0 {
                    if !(string == "") {
                        self.formatInput(aTextField: textField, aString: string, aRange: range)
                        return false
                    }
                    return true
                }
                return true
            }
            return true
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //  textField.layer.borderColor = UIColor.lightGray.cgColor
        self.setBorderToTextField(vBorder: .Bottom, withBorderColor: .gray, withBorderWidth: 1.0)
        let trimmedString = textField.text?.trimmingCharacters(in: .whitespaces)
        textField.text = trimmedString
        if self.textFieldBorderStyle != .None {
            self.delegate = self
        }
        
        //        if self.style == .Picker {
        //            self.resignFirstResponder()
        //        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if self.tag == 105 {
            return statusData.count
        } else if self.tag == 101 {
            return statusData.count
        }  else if self.tag == 102 {
            return data.count
        }  else if self.tag == 103 {
            return pickerData.count
        }  else if self.tag == 104 {
            return data.count
        } else {
            return data.count
        }
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.tag == 105 {
            return "\(String(describing: statusData[row]))"
        }else if statusData.count > 0 && self.tag == 101 {
            return "\(statusData[row])"
        }else  if self.tag == 102 {
            let productName = String(describing: data[row].value(forKey: "ProductName")!)
            DataManager.sharedInstance().selectedProductName = productName
            return "\(String(describing: data[row].value(forKey: "ProductName")!))"
        } else if pickerData.count > 0 && self.tag == 103 {
            return "\(pickerData[row])"
        }else  {
            return "\(String(describing: data[row].value(forKey: "Name")!))"
        }
        
        //return "\(String(describing: data[row].value(forKey: "Name")!))"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if self.tag == 105 {
            self.text = String(describing: statusData[row])
        } else if statusData.count > 0 && self.tag == 101 {
            self.text = "\(statusData[row])"
        }else if self.tag == 102 {
            self.text = String(describing: data[row].value(forKey: "ProductName")!)
        }else if pickerData.count > 0 && self.tag == 103 {
            self.text = "\(pickerData[row])"
        }
        else {
            if let name = data[row].value(forKey: "Name") as? String {
                self.text = name
            }
        }
        
        // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ValueSelectedNotification"), object: nil)
        
    }
    
    
    
}
