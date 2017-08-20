//
//  ViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 15/07/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit


class LoginViewController: BaseViewController, XMLParserDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: BSTextField!
    @IBOutlet weak var passwordTextField: BSTextField!
    
    var curentElement = ""
    var inputDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        automaticallyAdjustsScrollViewInsets = false
        setUpTextField()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextField() {
        
        emailTextField.rightImageName = "ic_avatar_inside_a_circle"
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.emailTextField.setStyle(.UserName)
        self.passwordTextField.setStyle(.Password)
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpTextField()
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.noNetworkConnection), name: NSNotification.Name(rawValue: "InternetConnecionLostNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
        
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        if formIsValid() {
            showProgressLoader()
            ServerManager.sharedInstance().getUserDetails(userName: emailTextField.text!, completion: { (result, data) in
                
                let parser = XMLParser(data: data)
                parser.delegate = self
                let success:Bool = parser.parse()
                
                if success {
                        if ServerManager.sharedInstance().userDetailsDict.count > 0 {
                        print(ServerManager.sharedInstance().userDetailsDict)
                        let userDetailsDict = ServerManager.sharedInstance().userDetailsDict
                        let responseCode = userDetailsDict.value(forKey: "ResponseCode") as! String
                        switch  responseCode {
                        case "200":
                            if let password = userDetailsDict.value(forKey: "Password") as? String , password == self.passwordTextField.text! {
                                DispatchQueue.main.async {
                                    self.emailTextField.text = ""
                                    self.passwordTextField.text = ""
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = self.inputDateFormat
                                    formatter.timeZone = TimeZone.current
                                    //        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
                                    formatter.dateFormat = "'at' h:mm a"
                                    formatter.amSymbol = "AM"
                                    formatter.pmSymbol = "PM"
                                    if let dateTime = UserDefaults.standard.value(forKey: "CurrentDate") as? Date {
                                        let isAttendenceMarked =  UserDefaults.standard.bool(forKey: "isAttendenceMarked")
                                        if formatter.calendar.isDateInToday(dateTime) && isAttendenceMarked  {
                                            
                                           let vc = self.storyboard?.instantiateViewController(withIdentifier: "attendenceVC")
                                          
                                            self.navigationController?.pushViewController(vc!, animated: false)
                                            self.performSegue(withIdentifier: "assignedLeadSegue", sender: self)
                                        } else {
                                            self.performSegue(withIdentifier: "attendenceSegue", sender: self)
                                        }
                                        
                                    } else {
                                        self.performSegue(withIdentifier: "attendenceSegue", sender: self)
                                    }

                                    
                                    
                                    self.hideProgressLoader()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.hideProgressLoader()
                                    self.showToast(message: worngIdOrPassword)
                                }
                            }
                            
                        case "404":
                            DispatchQueue.main.async {
                                self.hideProgressLoader()

                                self.showToast(message: worngIdOrPassword)
                            }
                        default:
                            DispatchQueue.main.async {
                                self.hideProgressLoader()
                                self.showToast(message: serverErrorMessage)
                            }
                            break
                            
                        }
                        
                    } else {
                            
                        DispatchQueue.main.async {
                            self.hideProgressLoader()
                            self.showToast(message: worngIdOrPassword)
                        }
                    }
                    
                }
                //                print(success)
            })
            // showToast(message: "Logged In Suceessfully")
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func formIsValid() -> Bool {
        
        let isEmpty = emailTextField.isEmpty(str: emailTextField.text!)
        if isEmpty.0{
            //showAlert(title: "Error", message: isEmpty.1)
            showToast(message: isEmpty.1)
        } else if passwordTextField.isEmpty(str: passwordTextField.text!).0 {
            //showAlert(title: "Error", message: passwordTextField.isEmpty(str: passwordTextField.text!).1)
            showToast(message: passwordTextField.isEmpty(str: passwordTextField.text!).1)
        } else {
            
            return true
        }
        return false
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        curentElement =  elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        let userDetailsDict: NSMutableDictionary = ServerManager.sharedInstance().userDetailsDict

        if curentElement == "ResponseCode" {
            userDetailsDict.setValue(string, forKey: "ResponseCode")
        }else if curentElement == "ID" {
            userDetailsDict.setValue(string, forKey: "ID")
        } else if curentElement == "Name" {
            userDetailsDict.setValue(string, forKey: "Name")
        }else if curentElement == "Password" {
            userDetailsDict.setValue(string, forKey: "Password")
        } else if curentElement == "FullName" {
            userDetailsDict.setValue(string, forKey: "FullName")
        } else if curentElement == "EmailID" {
            userDetailsDict.setValue(string, forKey: "EmailID")
        } else if curentElement == "CanUserLogin" {
            if string.lowercased() == "true" {
                userDetailsDict.setValue(true, forKey: "CanUserLogin")
                
            } else {
                userDetailsDict.setValue(false, forKey: "CanUserLogin")
        }
            
        } else if curentElement == "LoginAttempt" {
            userDetailsDict.setValue(string, forKey: "LoginAttempt")
        } else if curentElement == "RoleID" {
            userDetailsDict.setValue(string, forKey: "RoleID")
        }
        
    }
    
    private func textFieldDidEndEditing(_ textField: BSTextField) {
        
        let trimmedString = textField.text?.trimmingCharacters(in: .whitespaces)
        textField.text = trimmedString
            textField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.gray, withBorderWidth: 1)
        
    }
    
    
    private func textFieldDidBeginEditing(_ textField: BSTextField) {
        textField.setBorderToTextField(vBorder: .Bottom, withBorderColor: UIColor.blue, withBorderWidth: 1)
    }

    
}

