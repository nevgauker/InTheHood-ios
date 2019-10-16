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
        
        
        if collectionView.tag == 1 {
            return CGSize(width: 100.0, height: 45.0)

        }
        return CGSize(width: self.view.frame.size.width, height: 260.0)
    }
}

//
//extension MainScreenViewController:UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField.tag == 0{
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                self.createTitleBottomBorder.alpha = 1.0
//
//            }, completion: { (finished: Bool) in
//            })
//        }
//        if textField.tag == 1{
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                self.createPriceBottomBorder.alpha = 1.0
//
//            }, completion: { (finished: Bool) in
//            })
//        }
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//
//        self.createPriceTextField.resignFirstResponder()
//
//
//        if textField.tag == 0 {
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                self.createTitleBottomBorder.alpha = 0.0
//
//            }, completion: { (finished: Bool) in
//            })
//        }
//
//        if textField.tag == 1 {
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                self.createPriceBottomBorder.alpha = 0.0
//            }, completion: { (finished: Bool) in
//            })
//        }
//
//        return true
//
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.createPriceTextField.resignFirstResponder()
//        self.createTitleTextField.resignFirstResponder()
//        if textField.tag == 0 {
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                self.createTitleBottomBorder.alpha = 0.0
//
//            }, completion: { (finished: Bool) in
//            })
//        }
//
//        if textField.tag == 1 {
//            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
//                self.createPriceBottomBorder.alpha = 0.0
//            }, completion: { (finished: Bool) in
//            })
//        }
//
//        return true
//    }
//}

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
        
        let identifier = "GeneralItemCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        let item = DataManager.shared().items[indexPath.item]
        if let theCell = cell as? GeneralItemCell {
            theCell.setCell(item: item)
        }
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem =  DataManager.shared().items[indexPath.item]
        
        if selectedItem?.ownerId == DataManager.shared().user?._id {
            performSegue(withIdentifier: "editSegue", sender: self)

        }
        performSegue(withIdentifier: "displaySegue", sender: self)
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

extension MainScreenViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return DataManager.shared().distances.count
        }else if pickerView.tag == 1 {
            return DataManager.shared().types.count

        }
        //2
        if let categories = DataManager.shared().categories {
            return categories.count
        }
        return 0
    }
    
    
}
extension MainScreenViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return DataManager.shared().distances[row]
        }else if pickerView.tag == 1 {
            return DataManager.shared().types[row]
        }
        if let categories = DataManager.shared().categories {
            return categories[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            filter_distance =  DataManager.shared().distances[row]
        }else if pickerView.tag == 1 {
            filyter_type =  DataManager.shared().types[row]
        }else if pickerView.tag == 2 {
            if let categories = DataManager.shared().categories {
                filter_category =  categories[row]
            }
        }
        var filterUpdated = false
        
        if (filterDistanceLabel.text != filter_distance) {
            filterUpdated = true
        }
        filterDistanceLabel.text = filter_distance
        if (filterTypeLabel.text != filyter_type) {
            filterUpdated = true
        }
        filterTypeLabel.text = filyter_type
        if (filterCategoryLabel.text !=  filter_category) {
            filterUpdated = true
        }
        filterCategoryLabel.text = filter_category
        
        if filterUpdated {
            fetchItems(type: filyter_type, category: filter_category)
        }

        

        
    }
}

class MainScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var filterView: UIView!

    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    @IBOutlet weak var categoriesCollection: CategoriesCollectionView!
    let categories = ["aaaa", "abbb"]
    
    var selectedItem:Item?


    @IBOutlet weak var createScrollView: UIScrollView!
    
    @IBOutlet weak var createUserAvatar: UIImageView!
    
    @IBOutlet weak var createTitleTextField: UITextField!
    @IBOutlet weak var createTitleBottomBorder: UIView!
    @IBOutlet weak var createPriceBottomBorder: UIView!
    @IBOutlet weak var createCreateBtn: UIButton!

    @IBOutlet weak var createTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var createCurrencyBtn: UIButton!
    @IBOutlet weak var createPriceTextField: UITextField!
    @IBOutlet weak var createBarterView: UIView!
    @IBOutlet weak var createBarterTextView: UITextView!

    @IBOutlet weak var barterViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewUserAvatar: UIImageView!
    @IBOutlet weak var topViewUserNameLabel: UILabel!
    
    
    
    @IBOutlet weak var filterDistanceLabel: UILabel!
    @IBOutlet weak var filterTypeLabel: UILabel!
    @IBOutlet weak var filterCategoryLabel: UILabel!
    
    
    
    @IBOutlet weak var profiileView: UIView!
    
//
//    //create
//    var selectedImage:UIImage?
//    var type:String = "Sell"
//    var currency:String = Utils.currenciesNames()[0]
//    var selectedCategoryIndex:Int = 0
//    var barterFor = ""
    
    //filter
    
    var filter_distance = DataManager.shared().distances[0]
    var filyter_type = DataManager.shared().distances[0]
    var filter_category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topViewUserAvatar.layer.cornerRadius = topViewUserAvatar.frame.size.width/2
        topViewUserAvatar.clipsToBounds = true
        if let categories  = DataManager.shared().categories{
            filter_category = categories[0]
        }
        updateTopView()
        
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
    
    @IBAction func didPressDisplayProfile(_ sender: Any) {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [], animations: {
            if self.profiileView.alpha == 0.0 {
                self.profiileView.alpha = 1.0
            }else {
                self.profiileView.alpha = 0.0
                
            }
        }, completion: { (finished: Bool) in
        })
    }
    
    
    @IBAction func didPressSignOut(_ sender: UIButton) {
        NetworkingManager.shared().signOut()
    }

    @IBAction func didPressAdd(_ sender: UIButton) {
        performSegue(withIdentifier: "createSegue", sender: self)
    }
    @IBAction func didPressFilter(_ sender: UIButton) {
        if  sender.tag == 0 {
            sender.tag = 1
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.filterBtn.setTitle("DISMISS", for: .normal)
                var frame = self.filterView.frame
                frame.origin.y -= 170
                frame.size.height = 200
                self.filterView.frame = frame
                
                
            }, completion: { (finished: Bool) in
                self.filterBtn.backgroundColor = UIColor.red
                self.filterBtn.setTitleColor(UIColor.white, for: .normal)
                
            })
            addBtn.isEnabled = false
            
            
        }else {sender.tag = 0
            
            addBtn.isEnabled = true
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.filterBtn.setTitle("FILTER", for: .normal)
                var frame = self.filterView.frame
                frame.origin.y += 170
                frame.size.height = 30.0
                self.filterView.frame = frame
            }, completion: { (finished: Bool) in
                self.filterBtn.backgroundColor = UIColor.white
                self.filterBtn.setTitleColor(UIColor(red: 82.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
            })
            
        }
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
    
    func updateTopView() {
        
        if let theUser = DataManager.shared().user {
            topViewUserNameLabel.text = theUser.name
            let urlStr = theUser.userAvatar
            if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
                topViewUserAvatar.kf.setImage(with: imageUrl,placeholder: UIImage(named: "Avatar")){ result in
                    switch result {
                    case .success(let value):
                        self.topViewUserAvatar.image = value.image
                    case .failure(let error):
                        print("Error: \(error)")}
                }
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ItemViewController {
            if segue.identifier == "createSegue" {
                vc.screen = .create
            }
            if segue.identifier == "displaySegue" {
                vc.screen = .display
                vc.item = self.selectedItem

            }
            if segue.identifier == "editSegue" {
                vc.screen = .edit
                vc.item = self.selectedItem

            }
        }
     
    }
    
}
