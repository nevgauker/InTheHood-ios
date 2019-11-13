//
//  UserDetailsTableViewCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 06/11/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_id:String){
                 NetworkingManager.shared().fetchUser(_id: _id, completion: { error,data in
                     if error == nil {
                         DispatchQueue.main.async {
                             if let userDict = data?["user"] as? [ String : Any ]{
                                 if let name = userDict["name"] as? String {
                                     self.userNameLabel.text = name
                                     if let userImageUrl = userDict["userAvatar"] {
                                         if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: userImageUrl as! String){
                                             self.userImageView.kf.setImage(with: imageUrl) { result in
                                                 switch result {
                                                 case .success(let value):
                                                     self.userImageView.image = value.image
                                                 case .failure(let error):
                                                     print("Error: \(error)")}
                                             }
                                         }
        
                                     }
        
        
                                 }
        
                             }
                         }
                     }
        
                 })
    }

}
