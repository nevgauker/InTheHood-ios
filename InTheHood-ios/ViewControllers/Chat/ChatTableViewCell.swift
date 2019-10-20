//
//  ChatTableViewCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 18/09/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var otherUserAvatarImageView: UIImageView!
    
    @IBOutlet weak var textTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(user:User,message:Message){
        
        
        
        
        
        userAvatarImageView.layer.cornerRadius =  userAvatarImageView.frame.size.width/2
        userAvatarImageView.clipsToBounds = true
        textTextField.layer.cornerRadius = 15.0
        textTextField.clipsToBounds = true
        textTextField.text = message.text
        let urlStr = user.userAvatar
        if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
            userAvatarImageView.kf.setImage(with: imageUrl,placeholder: UIImage(named: "Avatar")){ result in
                switch result {
                case .success(let value):
                    if let currentUser = DataManager.shared().user {
                        if user._id  == currentUser._id {
                            self.userAvatarImageView.isHidden = false
                            self.otherUserAvatarImageView.isHidden = true
                            self.userAvatarImageView.image = value.image
                        }else {
                            self.userAvatarImageView.isHidden = true
                            self.otherUserAvatarImageView.isHidden = false
                            self.otherUserAvatarImageView.image = value.image
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")}
            }
        }
        
        
    }
}
