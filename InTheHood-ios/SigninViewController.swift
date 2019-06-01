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
                self.passwordBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        }else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 1.0
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

class SigninViewController: UIViewController {

    
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainScreen")
        self.view.window?.rootViewController = vc
        
    }
    @IBAction func didPressSignup(_ sender: UIButton) {
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    @IBAction func didPressForgotPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "forgotPasswordSegue", sender: self)
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
