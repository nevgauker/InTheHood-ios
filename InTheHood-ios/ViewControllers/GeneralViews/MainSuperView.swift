//
//  DismissKeyboardOnTapViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 02/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class MainSuperView: UIView {
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    
    
    
    @objc func tapView(sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
}
