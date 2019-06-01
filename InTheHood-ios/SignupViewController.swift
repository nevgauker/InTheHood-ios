//
//  SignupViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

extension SignupViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.nameBorder.alpha = 1.0
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        } else if textField.tag == 1 {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.nameBorder.alpha = 0.0
                self.emailBorder.alpha = 1.0
                self.passwordBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.nameBorder.alpha = 0.0
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 1.0
            }, completion: { (finished: Bool) in
            })
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            emailTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            passwordTextField.becomeFirstResponder()
        } else {
            didPressSignup(signupBtn)
        }
        return true
    }
}


class SignupViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameBorder: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailBorder: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordBorder: UIView!
    
    @IBOutlet weak var signupBtn: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.cornerRadius = 15.0

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var x = scrollView.contentSize
        
        x.height = 1200;
        scrollView.contentSize = x
    }
    
    //MARK: - actions
    @IBAction func didPressSignup(_ sender: UIButton) {
       
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
