//
//  ChatCollectionViewCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 06/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import Kingfisher


class ChatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    func setData(chat:Chat){
        
        let _id = chat.otherUserId
        
        NetworkingManager.shared().fetchUser(_id: _id, completion: { error,data in
            
            if error == nil {
                DispatchQueue.main.async {
                    if let userDict = data?["user"] as? [ String : Any ]{
                        let user:User = User(data: userDict)
                        if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: user.userAvatar){
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
        })
    }
}
