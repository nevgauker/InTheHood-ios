//
//  ForgotPasswordViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

extension ForgotPasswordViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.emailBorder.alpha = 1.0
                
            }, completion: { (finished: Bool) in
            })
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressSend(sendBtn)
        return true
    }
}


class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailBorder: UIView!
    @IBOutlet weak var sendBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.layer.cornerRadius = 15.0


        // Do any additional setup after loading the view.
    }
    //MARK: - actions
    @IBAction func didPressSend(_ sender: UIButton) {
        
    }
    @IBAction func didPressBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
