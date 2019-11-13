//
//  ItemDetailsCollectionViewCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 04/11/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class ItemDetailsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var itemImage: UIImageView!

    @IBOutlet weak var itemPriceLabel: UILabel!
    
    
    func setCell(item:Item) {
         setData(item: item)
         setCellGUI()
         
     }

     
     
     private func setCellGUI() {
                 
         
     }
     
     private func setData(item:Item) {
        
        itemPriceLabel.text = item.price + item.currency
        
        if item.type != "Sell" {
            itemPriceLabel.text = item.type
        }
//
//         titleLabel.text = item.title
//         priceLabel.text = item.price + item.currency
//         typeLabel.text = item.type
//         categoryLabel.text = item.category
//         distanceLabel.text = item.distanceSringFrom(location: LocationManager.shared().current)
         
         if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: item.itemImage){
             itemImage.kf.setImage(with: imageUrl) { result in
                 switch result {
                 case .success(let value):
                     self.itemImage.image = value.image
                 case .failure(let error):
                     print("Error: \(error)")}
             }
         }
         
         
//         NetworkingManager.shared().fetchUser(_id: item.ownerId, completion: { error,data in
//             
//             if error == nil {
//                 DispatchQueue.main.async {
//                     if let userDict = data?["user"] as? [ String : Any ]{
//                         if let name = userDict["name"] as? String {
//                             self.userNameLabel.text = name
//                             
//                             if let userImageUrl = userDict["userAvatar"] {
//                                 if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: userImageUrl as! String){
//                                     self.userImageView.kf.setImage(with: imageUrl) { result in
//                                         switch result {
//                                         case .success(let value):
//                                             self.userImageView.image = value.image
//                                         case .failure(let error):
//                                             print("Error: \(error)")}
//                                     }
//                                 }
//                                 
//                             }
//                             
//                        
//                         }
//                         
//                     }
//                 }
//             }
//             
//         })
     }
         
    
}
