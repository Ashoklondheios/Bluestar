//
//  leadSearchView.swift
//  Bluestar
//
//  Created by Ashok Londhe on 12/08/17.
//  Copyright © 2017 Ashok Londhe. All rights reserved.
//

import UIKit

class leadSearchView: UIView {

    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
    Bundle.main.loadNibNamed("leadSearchView", owner: self, options: nil)
        self.addSubview(view)
    }


}
