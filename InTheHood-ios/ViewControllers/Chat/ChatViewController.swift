//
//  ChatViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 18/09/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

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
    
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var textInputTextField: UITextField!
    @IBOutlet weak var chatTableBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var textInputBottomSpace: NSLayoutConstraint!
    
    var type:ChatScreentType = ChatScreentType.OtherUser
    
    var itemId:String = ""
    var itemOwnerId:String = ""
    var otherUserId:String = ""
    
    var otherUser:User!
    
    
    var chats:[Chat] = [Chat]()
    var selected:Chat!

    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.rowHeight = 100.0
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
       
        fetchData()
        textInputTextField.becomeFirstResponder()
     
    }
    
    func fetchData() {
        
        if self.type  == ChatScreentType.OtherUser {
            
            //fetch the other user data
            NetworkingManager.shared().fetchUser(_id: otherUserId, completion: {
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
                    
                }
            }
            
            
            
        })
    }
    
    
    func updateGUI() {
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
        }
    }
}
