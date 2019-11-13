//
//  ItemDetailsViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 04/11/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

extension ItemDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 100.0
        }
        
        if item.itIsMyItem() && indexPath.section == 1 {
            return 100.0
        }
        return 50.0
        
    }

    
}




extension ItemDetailsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if item.itIsMyItem() {
            if section == 0 {
                       return "General Infomation"
            }
           if section == 1 {
                       return "Location"
           }
        }else {
            if section == 0 {
                       return "General Infomation"
                   }
           if section == 1 {
                      return "User"
           }
           if section == 2 {
                       return "Location"
           }
        }
        
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if item.itIsMyItem() {
             return 2
        }
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
             return 4
        }
        if section == 1 {
            return 1
        }
        if section == 2 {
            return 1
        }
        return 0 
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section ==  0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "dataCell")!
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Title"
                cell.detailTextLabel?.text = item.title
            }
            if indexPath.row == 1 {
                cell.textLabel?.text = "Type"
                cell.detailTextLabel?.text = item.type
            }
            if indexPath.row == 2 {
                cell.textLabel?.text = "Category"
                cell.detailTextLabel?.text = item.category
            }
            if indexPath.row == 3 {
                cell.textLabel?.text = "Price"
                cell.detailTextLabel?.text = item.price + item.currency
                if item.price == ""  {
                    cell.detailTextLabel?.text = "0" + item.currency

                }
                if item.type == "Barter" {
                    cell.textLabel?.text = "Barter for"
                    cell.detailTextLabel?.text = item.barterFor
                }
            }
            
        }else if indexPath.section == 1 {
            
            
            if item.itIsMyItem() {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")!
                           
                           if let  theCell = cell  as? LocationTableViewCell {
                               //theCell.setData(_id:item.ownerId)
                           }
                
                
            }else {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell")!
                          
                          if let  theCell = cell  as? UserDetailsTableViewCell {
                              theCell.setData(_id:item.ownerId)
                          }
            }
          

        } else if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell")!
            
            if let  theCell = cell  as? LocationTableViewCell {
                //theCell.setData(_id:item.ownerId)
            }

        }
        
            
            

        return cell
    }
    
    
    
}
class ItemDetailsViewController: GeneralViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainActionBtn: UIButton!

    var item:Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item.itIsMyItem() {
            mainActionBtn.setTitle("Chats", for: .normal)
        }
        
        if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: item.itemImage){
                    itemImageView.kf.setImage(with: imageUrl) { result in
                        switch result {
                        case .success(let value):
                            self.itemImageView.image = value.image
                        case .failure(let error):
                            print("Error: \(error)")}
                    }
                }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    //open chat for other user or chats for me
    @IBAction func didPressMainAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "chatNav")
        let vc = (controller as! UINavigationController).viewControllers[0] as! ChatViewController
        vc.itemId = item!._id
        vc.itemOwnerId = item!.ownerId
        vc.item = self.item
        if item.itIsMyItem() {
             vc.type = ChatScreentType.ItemOwner
             self.present(controller, animated: true, completion: nil)
        }else {
                 vc.type = ChatScreentType.OtherUser
                 vc.otherUserId = DataManager.shared().user!._id
                 self.present(controller, animated: true, completion: nil)
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
