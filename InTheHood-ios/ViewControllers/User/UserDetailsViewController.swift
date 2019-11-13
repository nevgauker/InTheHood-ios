//
//  UserDetailsViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 13/11/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit


extension UserDetailsViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetailsCell")!
        
        
        
        if let theUser = user {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Name"
                cell.detailTextLabel?.text = theUser.name
            }else {
                cell.textLabel?.text = "Email"
                cell.detailTextLabel?.text = theUser.email
            }
        }
        return cell
    }
    
    
    
}

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userDetailsTableView: UITableView!
    
    var _id:String!
    private var user:User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        fetchUserDataIfNeeded()

        // Do any additional setup after loading the view.
    }
    // MARK: - Actions

    @IBAction func didPressMainAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func fetchUserDataIfNeeded(){
        
        if let currentUser = DataManager.shared().user {
            
            if currentUser._id == self._id {
                user = currentUser
                updateGUI()
            }else {
                   NetworkingManager.shared().fetchUser(_id: _id, completion: { error,data in
                                 if error == nil {
                                     DispatchQueue.main.async {
                                         if let userDict = data?["user"] as? [ String : Any ]{
                                            self.user = User(data: userDict)
                                            self.updateGUI()
                    
                                         }
                                     }
                                 }
                    
                             })
                
                
            }
            
            
            
        }
    }
    
    func updateGUI(){
            userDetailsTableView.reloadData()
            if let theUser = user {
                let urlStr = theUser.userAvatar
                                     if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
                                      userImageView.kf.setImage(with: imageUrl,placeholder: UIImage(named: "Avatar")){ result in
                                             switch result {
                                             case .success(let value):
                                                self.userImageView.image = value.image
                                             case .failure(let error):
                                                 print("Error: \(error)")}
                                        }
                }
            }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
