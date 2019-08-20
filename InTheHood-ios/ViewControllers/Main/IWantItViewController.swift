//
//  IWantItViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 18/08/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit


extension IWantItViewController:UITextViewDelegate {
    
    
    
}
class IWantItViewController: UIViewController {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    
    var item:Item!

    
    @IBOutlet weak var messegeTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.clipsToBounds = true
        messegeTextView.addDoneToolbar(onDone: (target:self, action: #selector(didPressDone)))
        setUserView()
        setItemView()
        messegeTextView.becomeFirstResponder()

      
    }
    
    func setUserView(){
        
        let ownerId = item.ownerId
        NetworkingManager.shared().fetchUser(_id: ownerId, completion: { error, data in
            if error ==  nil {
                DispatchQueue.main.async {
                    if let userDict = data?["user"] as? [ String : Any ]{
                        if let name = userDict["name"] as? String {
                            self.userNameLabel.text = name
                            if let userImageUrl = userDict["userAvatar"] {
                                if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: userImageUrl as! String){
                                    self.userImageView.kf.setImage(with: imageUrl,placeholder: UIImage(named: "Avatar")) { result in
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
    func setItemView() {
        itemTitleLabel.text = item.title
        itemPriceLabel.text = item.price + item.currency
        let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: item.itemImage)
        itemImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "Avatar")) { result in
            switch result {
            case .success(let value):
                self.itemImageView.image = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

 
    
    
    @objc func didPressDone() {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
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
