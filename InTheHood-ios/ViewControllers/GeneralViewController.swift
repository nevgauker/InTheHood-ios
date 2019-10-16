//
//  GeneralViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 06/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class GeneralViewController: UIViewController {

    
    var loader:NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let rect = CGRect(x: 0, y: 0, width: 60.0, height: 60)
        loader = NVActivityIndicatorView(frame: rect, type: nil, color: nil, padding: 10.0)
        loader.backgroundColor = UIColor.black
        loader.center = self.view.center
        loader.layer.cornerRadius = 10.0
        loader.dropShadow(scale: true)
        self.view.addSubview(loader)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapView(sender:)))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    func startLoader() {
        loader.startAnimating()
        
    }
    func stopLoader() {
        loader.stopAnimating()
    }
    @objc func tapView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
