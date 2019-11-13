//
//  MainScreenViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import collection_view_layouts

extension MainScreenViewController:UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
        let val = self.view.frame.size.width / 2
        return CGSize(width: val, height: val)
    }
}

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
                return DataManager.shared().items.count
        }
        if let categories = DataManager.shared().categories {
            return categories.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       // let identifier = "GeneralItemCell"
       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        let identifier = "ItemDetailsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        
        let item = DataManager.shared().items[indexPath.item]
        if let theCell = cell as? ItemDetailsCollectionViewCell {
            theCell.setCell(item: item)
        }
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem =  DataManager.shared().items[indexPath.item]
        performSegue(withIdentifier: "itemDetailsSegue", sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            cell.alpha = 0.0
            UIView.animate(withDuration: 1.0, animations: {
                cell.alpha = 1.0
            }, completion: {
                (value: Bool) in
            })
        }
    }
}

class MainScreenViewController: UIViewController,didSelectCategory {
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userBtn: UIButton!
   

    var selectedItem:Item?
    var selectedCategory = ""
       
    var x = 0

    var filter_distance = DataManager.shared().distances[0]
    var filyter_type = DataManager.shared().types[0]
    var filter_category = DataManager.shared().categories![0]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = 20.0
        addBtn.clipsToBounds = true
        if let categories  = DataManager.shared().categories{
            filter_category = categories[0]
        }
        fetchUserImage()
        
//
//        createBarterTextView.layer.cornerRadius = 15.0
//        createUserAvatar.layer.cornerRadius = 15.0
//        createCreateBtn.layer.cornerRadius = 15.0
        
        
        if DataManager.shared().needToUpdatePushToken {
            if let token = DataManager.shared().loadPushToken() {
                if let user  = DataManager.shared().user {
                    NetworkingManager.shared().updateMyUserPush(email: user.email, token: token, completion: {
                        error,data in
                    })
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems(type: filyter_type, category: filter_category)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //var contentSize = createScrollView.contentSize
        //contentSize.height = 2000
        //contentSize.width = self.view.frame.size.width

        //createScrollView.contentSize = contentSize
        
    }
    //MARK: - actions
    
    @IBAction func didChangeType(_ sender: UISegmentedControl) {
        self.filyter_type = DataManager.shared().types[sender.selectedSegmentIndex]
        fetchItems(type: filyter_type, category: filter_category)
        
    }
    @IBAction func didPressDisplayProfile(_ sender: Any) {
        
        performSegue(withIdentifier: "userSegue", sender: self)
        
//        UIView.animate(withDuration: 0.7, delay: 0.0, options: [], animations: {
//            if self.profiileView.alpha == 0.0 {
//                self.profiileView.alpha = 1.0
//            }else {
//                self.profiileView.alpha = 0.0
//
//            }
//        }, completion: { (finished: Bool) in
//        })
    }
    
    @IBAction func didPressSelectCategory(_ sender: Any) {
        x = 0
        performSegue(withIdentifier: "categorySelectSegue", sender: self)
    }
    
    @IBAction func didPressSignOut(_ sender: UIButton) {
        
        NetworkingManager.shared().signOut()
    }

    @IBAction func didPressAdd(_ sender: UIButton) {
        x = 1
        performSegue(withIdentifier: "categorySelectSegue", sender: self)
    }
  

    func fetchItems(type:String,category:String) {
        
        var dist:Float = -1.0
        if filter_distance != DataManager.shared().distances[0] {
            if filter_distance == DataManager.shared().distances[1] {
                dist = 3.0
            }
            if filter_distance == DataManager.shared().distances[2] {
                 dist = 10.0
            }
            if filter_distance == DataManager.shared().distances[3] {
                dist = 30.0
            }
        }else {
            dist = -1.0
        }
        
        if dist == -1 {
            //all
            NetworkingManager.shared().getItems(location: nil , distance: dist,type:type, category: category, completion: {error,data in
                if error == nil {
                    DataManager.shared().loadItems(data:data)
                    DispatchQueue.main.async {
                        
                        self.collectionView.reloadData()
                    }
                }
            })
            
            
            
        }else {
            
            if let loc = LocationManager.shared().current {
                
                
                let loc = ["latitude" : loc.coordinate.latitude, "longitude" : loc.coordinate.longitude]
                
                NetworkingManager.shared().getItems(location: loc , distance: dist,type:type, category: category, completion: {error,data in
                    if error == nil {
                        DataManager.shared().loadItems(data:data)
                        DispatchQueue.main.async {
                            
                            self.collectionView.reloadData()
                        }
                    }
                })
                
                
            }
        }
        
    }
    
    func fetchUserImage(){
        if let theUser = DataManager.shared().user {
                   let urlStr = theUser.userAvatar
                   if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
                    userBtn.imageView?.kf.setImage(with: imageUrl,placeholder: UIImage(named: "Avatar")){ result in
                           switch result {
                           case .success(let value):
                            self.userBtn.setImage(value.image, for: .normal)
                           case .failure(let error):
                               print("Error: \(error)")}
                       }
                   }
                   
               }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     
        
        if segue.identifier == "createSegue2" {
            let nav:UINavigationController = segue.destination as! UINavigationController
            
            let vc:DetailsViewController = nav.viewControllers[0] as! DetailsViewController
            
            vc.category = selectedCategory
            
        }
        
        if segue.identifier == "categorySelectSegue" {
            let vc:CategorySelectionViewController = segue.destination as! CategorySelectionViewController
            if x == 1 {
                vc.screen_type = Screen_type.creation
            }
            vc.delegate = self
            
        }
        
        if segue.identifier == "itemDetailsSegue" {
                  let vc:ItemDetailsViewController = segue.destination as! ItemDetailsViewController
            
            vc.item  = self.selectedItem!
        }
        
        if segue.identifier == "userSegue" {
            
            let vc:UserDetailsViewController = segue.destination as! UserDetailsViewController
            
            if let current = DataManager.shared().user {
                vc._id = current._id
            }else {
                
                
            }

            
        }

        
        
    }
        
     
    
    // MARK: didSelectCategory
    
    func didSelect(category:String) {
        if x == 0{
            if category == "All"  {
                categoryBtn.setTitle(category, for: .normal)
                categoryBtn.setImage(nil, for: .normal)
            }else {
                categoryBtn.setTitle("", for: .normal)
                categoryBtn.setImage(UIImage(named: category), for: .normal)
            }
            
            self.filter_category = category
            self.fetchItems(type: self.filyter_type, category: self.filter_category)
        }
        if x == 1{
            selectedCategory = category
            performSegue(withIdentifier: "createSegue2", sender: self)

        }
    
    }

    
}
