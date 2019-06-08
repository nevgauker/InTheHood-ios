//
//  SigninViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

extension SigninViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.emailBorder.alpha = 1.0
                self.emailBorder.backgroundColor = UIColor.black

                self.passwordBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        }else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 1.0
                self.passwordBorder.backgroundColor = UIColor.black

            }, completion: { (finished: Bool) in
            })
        }

        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }else {
            didPressSignin(signinBtn)
        }
        return true
    }
}

class SigninViewController: GeneralViewController {

    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailBorder: UIView!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var passwordBorder: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signinBtn.layer.cornerRadius = 15.0

        // Do any additional setup after loading the view.
    }
    //MARK: - actions
    @IBAction func didPressSignin(_ sender: UIButton) {
        
        
        if dataValidation() {
            startLoader()
            let email = emailTextField.text!
            let password = passwordTextField.text!
            NetworkingManager.shared().signin(email: email, password: password,completion: {
                error,data in
                
                self.stopLoader()
                if error == nil {
                    if let userData:[String:Any] = data?["user"] as? [String:Any] {
                        let user:User = User(data: userData)
                        DataManager.shared().user = user
                        if let token:String = data?["token"] as? String {
                            _ = DataManager.shared().saveToken(token: token)
                            _ = DataManager.shared().saveUser(user: user)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.setRootmainViewController()
                        }else {
                            print("token is missing")
                        }
                    }else {
                        print("user is missing")
                    }
                }
            })
            
        }
    }
    @IBAction func didPressSignup(_ sender: UIButton) {
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    @IBAction func didPressForgotPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: self)
    }
    
    func dataValidation()->Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailBorder.alpha = 0.0
        passwordBorder.alpha = 0.0
        var validationComplete:Bool = true
        if  emailTextField.text == nil || emailTextField.text?.count == 0 {
            emailBorder.alpha = 1.0
            emailBorder.backgroundColor = UIColor.red
            validationComplete =  false
        }
        if  passwordTextField.text == nil || passwordTextField.text?.count == 0 {
            passwordBorder.alpha = 1.0
            passwordBorder.backgroundColor = UIColor.red
            validationComplete =  false
        }
        return validationComplete
    }
}
