//
//  GeneralItemCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 03/07/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import Kingfisher


class GeneralItemCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    
    
    func setCell(item:Item) {
        setData(item: item)
        setCellGUI()
        
    }

    
    
    private func setCellGUI() {
        
        mainView.layer.cornerRadius = 5.0
        bottomView.layer.cornerRadius = 5.0

        itemImage.layer.cornerRadius = 5.0

        mainView.layer.borderWidth = 0.5
        mainView.layer.borderColor =  UIColor.lightGray.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        
    }
    
    private func setData(item:Item) {
        
        titleLabel.text = item.title
        priceLabel.text = item.price + item.currency
        typeLabel.text = item.type
        categoryLabel.text = item.category
        
        if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: item.itemImage){
            itemImage.kf.setImage(with: imageUrl) { result in
                switch result {
                case .success(let value):
                    self.itemImage.image = value.image
                case .failure(let error):
                    print("Error: \(error)")}
            }
        }
        
        
        NetworkingManager.shared().fetchUser(_id: item.ownerId, completion: { error,data in
            
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


