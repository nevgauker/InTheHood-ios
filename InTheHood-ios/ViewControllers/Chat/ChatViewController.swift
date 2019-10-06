//
//  ChatViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 18/09/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit


extension ChatViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ChatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCollectionViewCell", for: indexPath) as!
            ChatCollectionViewCell
        cell.setData(chat: self.chats[indexPath.item])
        if indexPath.item == self.selectedIndex {
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.black.cgColor
        }else {
            cell.layer.borderWidth = 0.0

        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
}

extension ChatViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.item
        self.selected = self.chats[indexPath.item]
        self.updateSelected()
    }
    
}



extension ChatViewController : UITableViewDelegate {
    
}

extension ChatViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell") as! ChatTableViewCell
        if let c = self.selected {
            let m = c.messages[indexPath.row]
            if m.userId == otherUser._id {
                //other user
                cell.setData(user: self.otherUser, message: m)
            }else if let u = DataManager.shared().user {
                cell.setData(user: u, message: m)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let c = self.selected {
            return c.messages.count
        }
        return 0
    }
    
}


enum ChatScreentType{
    case OtherUser
    case ItemOwner
}

class ChatViewController: UIViewController {
    
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var textInputTextField: UITextField!
    @IBOutlet weak var chatTableBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var textInputBottomSpace: NSLayoutConstraint!
    //top view
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var chatsCollectionView: UICollectionView!
    
    var type:ChatScreentType = ChatScreentType.OtherUser
    
    var itemId:String = ""
    var itemOwnerId:String = ""
    var otherUserId:String = ""
    
    var otherUser:User!
    var item:Item?
    
    
    var chats:[Chat] = [Chat]()
    var selected:Chat!
    var selectedIndex = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.rowHeight = 100.0
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        setTopView()
        fetchData()
        textInputTextField.becomeFirstResponder()
     
    }
    
    func setTopView(){
        itemTitleLabel.text = item?.title
        if let str = item?.price{
            if let str2 = item?.currency{
                itemPriceLabel.text = str + " " + str2

            }
        }
        if  let urlStr = item?.itemImage {
            if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
                itemImageView.kf.setImage(with: imageUrl,placeholder: UIImage(named: "Avatar")){ result in
                    switch result {
                    case .success(let value):
                        self.itemImageView.image = value.image
                    case .failure(let error):
                        print("Error: \(error)")}
                }
            }
        }
    }
 
    
    func fetchData() {
        
        if self.type  == ChatScreentType.OtherUser {
            
            topViewHeight.constant = 0
            updateViewConstraints()
            
            //fetch the other user data
            NetworkingManager.shared().fetchUser(_id: itemOwnerId, completion: {
                error,data in
                if error == nil {
                    if let userData = data!["user"] as? [String : Any] {
                        self.otherUser = User(data: userData)
                        
                        // fetch a single chat of create a new one if needed
                        self.fetchChat()
                    }
                    
                }
                
            })
        }else if  self.type  == ChatScreentType.ItemOwner{
                // fetch a single chat of create a new one if needed
                self.fetchChats()
            // fetch all chats related to the item . no creation of a new one is needed
            
        }
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            textInputBottomSpace.constant = keyboardHeight
            chatTableBottomSpace.constant = keyboardHeight + textInputView.frame.size.height
            self.updateViewConstraints()
            
        }
    }
    
    @IBAction func didPressSend(_ sender: Any) {
        
        
        if let text = textInputTextField.text {
              if let user = DataManager.shared().user {
                NetworkingManager.shared().addMessageToChat(_id: selected._id, userId: user._id, text: text, completion: {
                    error,data in
                    if error == nil {
                        if let chatData = data!["chat"] as? [String : Any]{
                            let chat:Chat = Chat(data: chatData)
                            self.selected = chat
                            self.updateGUI()
                        }
                    }
                })
            }
        }else {
            print("write something")
        }
        
    
        
    }

    @IBAction func didPressBack(_ sender: Any) {
          dismiss(animated: true, completion: nil)
    }
    
    
    func fetchChat() {
        NetworkingManager.shared().fetchChat(itemId: itemId, itemOwnerId: itemOwnerId, otherUserId: otherUserId, completion: {
            error,data in
            
            if error  == nil {
                if let chatData = data!["chat"]  as? [String : Any] {
                    self.chats.append(Chat(data: chatData))
                    self.selected = self.chats[0]
                    self.updateGUI()
                    
                }else {
                    NetworkingManager.shared().createChat(itemId: self.itemId, itemOwnerId: self.itemOwnerId, otherUserId: self.otherUserId, completion: {
                        error,data in
                        if error  == nil {
                            if let chatData = data!["chat"]  as? [String : Any] {
                                self.chats.append( Chat(data: chatData))
                                self.selected = self.chats[0]

                                self.updateGUI()
                                
                                
                            }
                        }
                    })
                }
            }
        })
    }
    
    func fetchChats() {
        NetworkingManager.shared().fetchChatsForItem(itemId: self.itemId, itemOwnerId: self.itemOwnerId, completion: {
            error,data in
            
            if error  == nil {
                if let chatsData = data!["chats"] as? [[String : Any]]{
                    for chatData in chatsData {
                        let chat:Chat = Chat(data: chatData)
                        self.chats.append(chat)
                    }
                    if self.chats.count > 0 {
                        self.selected = self.chats[0]
                        self.updateSelected()
                       
                    }
                    
                }
            }
            
            
            
        })
    }
    
    func updateSelected(){
        self.otherUserId = self.selected.otherUserId
        NetworkingManager.shared().fetchUser(_id: self.otherUserId, completion: {
            error,data in
            if error == nil {
                if let userData = data!["user"] as? [String : Any] {
                    self.otherUser = User(data: userData)
                }
                self.updateGUI()
                
            }
            
        })
        
    }
    
    
    func updateGUI() {
        DispatchQueue.main.async {
            
            self.chatTableView.reloadData()
            self.chatsCollectionView.reloadData()
            
            if self.selected.messages.count > 0 {
                self.chatTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}
