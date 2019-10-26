//
//  SocialSigninViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 26/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FacebookLogin

extension SocialSigninViewController:LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.width(480).height(480)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    if let r = result as? [String : Any]{
                        self.facebookResult = r
                        let email = r["email"] as! String
                        NetworkingManager.shared().signin(email: email, password: nil, facebookToken: AccessToken.current?.tokenString, googleToken: nil, completion: { error,data in
                            if error == nil {
                                if let userData:[String:Any] = data?["user"] as? [String:Any] {
                                    let user:User = User(data: userData)
                                    DataManager.shared().user = user
                                    if let token:String = data?["token"] as? String {
                                        _ = DataManager.shared().saveToken(token: token)
                                        _ = DataManager.shared().saveUser(user: user)
                                        NetworkingManager.shared().setDefaultHeaders(token: token)
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.setRootmainViewController()
                                    }else {
                                        print("token is missing")
                                    }
                                }
                            }else {
                                 self.didPressSignup(self.signupBtn)
                            }
                        })
                    }
                }
            })
        }
    }
    
}


class SocialSigninViewController:  GeneralViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var signupBtn: UIButton!

    @IBOutlet weak var userYourMailBtn: UIButton!
    @IBOutlet weak var googleSigninBtn: GIDSignInButton!
    
    var facebookResult:[String : Any]?
    var googleUser:GIDGoogleUser?
    let space:CGFloat = 10
    
    let loginButton:FBLoginButton = {
               let btn = FBLoginButton(permissions: [ .publicProfile, .email, ])
               return btn
           }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.delegate = self
        loginButton.center = view.center
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        view.addSubview(loginButton)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var frame = loginButton.frame
        
        frame.origin.y = googleSigninBtn.frame.origin.y - frame.size.height - space
        loginButton.frame = frame
       
    }
       
    
    
    
    
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                       withError error: Error!) {
                 if let error = error {
                     if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                         print("The user has not signed in before or they have since signed out.")
                     } else {
                         print("\(error.localizedDescription)")
                     }
                     return
                 }
                 // Perform any operations on signed in user here.
           
           
               self.googleUser = user
           
           
                 //let userId = user.userID                  // For client-side use only!
                 let idToken = user.authentication.idToken // Safe to send to the server
                 //let fullName = user.profile.name
                // let givenName = user.profile.givenName
                 //let familyName = user.profile.familyName
                 let googleMail = user.profile.email
           
           
           NetworkingManager.shared().signin(email: googleMail!, password: nil, facebookToken:nil, googleToken:idToken, completion: { error,data in
                                      if error == nil {
                                          if let userData:[String:Any] = data?["user"] as? [String:Any] {
                                              let user:User = User(data: userData)
                                              DataManager.shared().user = user
                                              if let token:String = data?["token"] as? String {
                                                  _ = DataManager.shared().saveToken(token: token)
                                                  _ = DataManager.shared().saveUser(user: user)
                                                  NetworkingManager.shared().setDefaultHeaders(token: token)
                                                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                  appDelegate.setRootmainViewController()
                                              }else {
                                                  print("token is missing")
                                              }
                                          }
                                      }else {
                                           self.didPressSignup(self.signupBtn)
                                      }
                                  })
           
           
           
               
    }
    
    
    @IBAction func didPressUseYourMail(_ sender: Any) {
        
        performSegue(withIdentifier: "emailSignSegue", sender: self)
    }
    
    @IBAction func didPressSignup(_ sender: UIButton) {
           performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "signupSegue" {
           let vc:SignupViewController = segue.destination as! SignupViewController
           vc.facebookResult = self.facebookResult
           vc.googleUser = googleUser
           
       }
   }
}
