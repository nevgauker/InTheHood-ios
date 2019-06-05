//
//  SignupViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import CropViewController

extension SignupViewController:CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

        
        self.dismiss(animated: true , completion: {
           DispatchQueue.main.async {
                self.userAvatarImageView.image = image
                self.selectedImage = image
                self.userAvatarImageView.layer.borderWidth = 0.0
                self.nameBorder.alpha = 0.0
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 0.0
            }
            
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.dismiss(animated: true , completion: {})
    }
    
}


extension SignupViewController:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true , completion: {
            
            if let img = info[.originalImage] as? UIImage{
                
                  self.presentCropViewController(img: img)
            }
            
            
        })
        
      
    }
}

extension SignupViewController:UINavigationControllerDelegate {
    
    
}

extension SignupViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0 {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.nameBorder.alpha = 1.0
                self.nameBorder.backgroundColor = UIColor.black
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        } else if textField.tag == 1 {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.nameBorder.alpha = 0.0
                self.emailBorder.alpha = 1.0
                self.emailBorder.backgroundColor = UIColor.black
                self.passwordBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.nameBorder.alpha = 0.0
                self.emailBorder.alpha = 0.0
                self.passwordBorder.alpha = 1.0
                self.passwordBorder.backgroundColor = UIColor.black

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
    
    @IBOutlet weak var userAvatarImageView: UIImageView!

    
    @IBOutlet weak var signupBtn: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width / 2
        userAvatarImageView.clipsToBounds = true
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
        if dataValidation() {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            let name = nameTextField.text!

            NetworkingManager.shared().signup(email: email, password: password, name: name, avatar: selectedImage!)
            
        }
    }
    @IBAction func didPressBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didPressSelectImage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Image", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title:"Gallery", style: .default , handler:{ (UIAlertAction)in
            if let picker =  Utils.getImagePicker(library: true, delegate: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
                self.present(picker, animated: true, completion: nil)
            } else {
                print("source is not avalible")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            if let picker =  Utils.getImagePicker(library: false, delegate: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
                self.present(picker, animated: true, completion: nil)
            } else {
                print("source is not avalible")
            }

        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        
    }
    
    
    func dataValidation()->Bool {
        
        
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameBorder.alpha = 0.0
        emailBorder.alpha = 0.0
        passwordBorder.alpha = 0.0



        var validationComplete:Bool = true
        
        if  nameTextField.text == nil || nameTextField.text?.count == 0 {
            nameBorder.alpha = 1.0
            nameBorder.backgroundColor = UIColor.red
            validationComplete =  false
        }
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
        if  selectedImage == nil  {
            
            userAvatarImageView.layer.borderWidth = 2.0
            userAvatarImageView.layer.borderColor = UIColor.red.cgColor
            validationComplete =  false
        }
        return validationComplete
    }
    
    
    func presentCropViewController(img:UIImage) {
        DispatchQueue.main.async {
            let vc = CropViewController(croppingStyle: .circular, image: img)
            vc.delegate = self as CropViewControllerDelegate
            self.present(vc, animated: false, completion: nil)
        }
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
