//
//  UIViewController.swift
//  Bluestar
//
//  Created by Ashok Londhe on 17/07/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 40, y: self.view.frame.size.height-120, width: self.view.frame.size.width - 80, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 6)
        toastLabel.font = UIFont.systemFont(ofSize: 13)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = toastLabel.frame.size.height/2;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    
}
