//
//  MainScreenViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import collection_view_layouts
import CropViewController
import LocationPickerViewController


extension MainScreenViewController:UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.layer.borderWidth = 0.0
        barterFor = textView.text
        return true
    }
}


extension MainScreenViewController:CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int){
        self.dismiss(animated: true , completion: {
            DispatchQueue.main.async {
                self.createUserAvatar.image = image
                self.createUserAvatar.layer.borderWidth = 0.0
                self.selectedImage = image
            }
            
        })
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        
        self.dismiss(animated: true , completion: {
            DispatchQueue.main.async {
                self.createUserAvatar.image = image
                self.createUserAvatar.layer.borderWidth = 0.0
                self.selectedImage = image
            }
            
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.dismiss(animated: true , completion: {})
    }
    
}

extension MainScreenViewController:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true , completion: {
            
            if let img = info[.originalImage] as? UIImage{
                
                self.presentCropViewController(img: img)
            }
            
            
        })
        
        
    }
}

extension MainScreenViewController:UINavigationControllerDelegate {
    
    
}

extension MainScreenViewController:UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView.tag == 1 {
            return CGSize(width: 100.0, height: 45.0)

        }
        return CGSize(width: 414.0, height: 260.0)
    }
}


extension MainScreenViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 0{
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createTitleBottomBorder.alpha = 1.0
               
            }, completion: { (finished: Bool) in
            })
        }
        if textField.tag == 1{
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createPriceBottomBorder.alpha = 1.0
                
            }, completion: { (finished: Bool) in
            })
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.createPriceTextField.resignFirstResponder()
        
        
        if textField.tag == 0 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createTitleBottomBorder.alpha = 0.0
                
            }, completion: { (finished: Bool) in
            })
        }
        
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createPriceBottomBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        }
        
        return true

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.createPriceTextField.resignFirstResponder()
        self.createTitleTextField.resignFirstResponder()
        if textField.tag == 0 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createTitleBottomBorder.alpha = 0.0
                
            }, completion: { (finished: Bool) in
            })
        }
        
        if textField.tag == 1 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createPriceBottomBorder.alpha = 0.0
            }, completion: { (finished: Bool) in
            })
        }
        
        return true
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
        
        var identifier = "GeneralItemCell"
        
        if  collectionView.tag == 1 {
            identifier = "CategoryCell"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if  collectionView.tag == 1 {
            let theCell = cell as! CategoryCell
            if let categories = DataManager.shared().categories {
                theCell.categoryNamelabel.text = categories[indexPath.item]
                if indexPath.item == self.selectedCategoryIndex {
                   theCell.backgroundColor = Utils.fillColor()
                    theCell.categoryNamelabel.textColor = UIColor.white
                }else {
                    theCell.backgroundColor = UIColor.white
                    theCell.categoryNamelabel.textColor = UIColor.black

                }
            }
            
            
        }else {
            
            let item = DataManager.shared().items[indexPath.item]
            if let theCell = cell as? GeneralItemCell {
                theCell.setCell(item: item)
                
            }
            
        }
        
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  collectionView.tag == 1 {
            self.selectedCategoryIndex = indexPath.item
            self.categoriesCollection.reloadData()
        }
        
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
            fetchItems()
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

    
    //create
    var selectedImage:UIImage?
    var type:String = "Sell"
    var currency:String = Utils.currenciesNames()[0]
    var selectedCategoryIndex:Int = 0
    var barterFor = ""
    
    //filter
    
    var filter_distance = DataManager.shared().distances[0]
    var filyter_type = DataManager.shared().distances[0]
    var filter_category = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let categories  = DataManager.shared().categories{
            filter_category = categories[0]
        }
        fetchItems()
        updateTopView()
        createBarterTextView.layer.cornerRadius = 15.0
        createUserAvatar.layer.cornerRadius = 15.0
        createCreateBtn.layer.cornerRadius = 15.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var contentSize = createScrollView.contentSize
        contentSize.height = 2000
        createScrollView.contentSize = contentSize
        
    }
    //MARK: - actions
    @IBAction func didPressSignOut(_ sender: UIButton) {
        NetworkingManager.shared().signOut()
    }

    @IBAction func didPressAdd(_ sender: UIButton) {
        if  sender.tag == 0 {
            sender.tag = 1
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createView.alpha = 1.0
                self.addBtn.setTitle("CANCEL", for: .normal)

            }, completion: { (finished: Bool) in
                self.addBtn.backgroundColor = UIColor.red

            })
            filterBtn.isEnabled = false
            
            
        }else {sender.tag = 0
        
            filterBtn.isEnabled = true
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.createView.alpha = 0.0
                self.addBtn.setTitle("ADD", for: .normal)

                
                
            }, completion: { (finished: Bool) in
                   self.addBtn.backgroundColor = UIColor(red: 82.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    self.resetCreateView()

            })
            
        }
        
        
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
    @IBAction func didPressCreateyBtn(_ sender: Any) {
        
        
        if dataValidation() {
         
            
            let locationPicker = LocationPicker()
            locationPicker.pickCompletion = { (pickedLocationItem) in
                
                self.createItemWithLocation(location: pickedLocationItem)
                // Do something with the location the user picked.
            }
            locationPicker.addBarButtons()
            // Call this method to add a done and a cancel button to navigation bar.
            
            let navigationController = UINavigationController(rootViewController: locationPicker)
            present(navigationController, animated: true, completion: nil)
            
            
        }
    }

    @IBAction func didPresscreateImageSelectionBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Image", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title:"Gallery", style: .default , handler:{ (UIAlertAction)in
            if let picker =  Utils.getImagePicker(library: true, delegate: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
                self.present(picker, animated: true, completion: nil)
            } else {
                print("source is not avalible")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            if let picker =  Utils.getImagePicker(library: false, delegate: self as UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
                self.present(picker, animated: true, completion: nil)
            } else {
                print("source is not avalible")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        
    }
    
    
    @IBAction func typeDidChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 1 {
            //donate
            type = "Donate"
            createPriceTextField.text = "0"
            createPriceTextField.isUserInteractionEnabled = false
            createCurrencyBtn.isEnabled = false

            barterViewHeight.constant = 0.0
            createView.updateConstraints()
    
        }else if sender.selectedSegmentIndex == 0 {
            type = "Sell"
            createCurrencyBtn.isEnabled = true
            createPriceTextField.isUserInteractionEnabled = true
            barterViewHeight.constant = 0.0
            createView.updateConstraints()

        }else {
            type = "Barter"
            createCurrencyBtn.isEnabled = false
            createPriceTextField.text = "0"
            createPriceTextField.isUserInteractionEnabled = false
            barterViewHeight.constant = 120.0
            createView.updateConstraints()
        }
        
    }
    
    
    @IBAction func didPressCreateCurrencyBtn(_ sender: Any) {
        
        // let locale = Locale.current
        //let currencySymbol = locale.currencySymbol!
        // let currencyCode = locale.currencyCode!
        
        createPriceTextField.resignFirstResponder()
        createTitleTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.createPriceBottomBorder.alpha = 0.0
            self.createTitleBottomBorder.alpha = 0.0
        }, completion: { (finished: Bool) in
           
        })
        
        let alert = UIAlertController(title: "Currency", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title:Utils.currenciesNames()[0] + " - " + Utils.currenciesStrings()[0], style: .default , handler:{ (UIAlertAction)in
            self.createCurrencyBtn.setTitle(Utils.currenciesNames()[0], for: .normal)
            self.currency = Utils.currenciesNames()[0]
        }))
        
        alert.addAction(UIAlertAction(title: Utils.currenciesNames()[1] + " - " + Utils.currenciesStrings()[1], style: .default , handler:{ (UIAlertAction)in
            self.createCurrencyBtn.setTitle(Utils.currenciesNames()[1], for: .normal)
            self.currency = Utils.currenciesNames()[1]

            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func presentCropViewController(img:UIImage) {
        DispatchQueue.main.async {
            let vc = CropViewController(croppingStyle: .default, image: img)
            vc.aspectRatioPreset = .presetSquare
            vc.delegate = self as CropViewControllerDelegate
            self.present(vc, animated: false, completion: nil)
        }
    }
    func dataValidation()->Bool {

        createTitleTextField.resignFirstResponder()
        createPriceTextField.resignFirstResponder()
        createTitleBottomBorder.alpha = 0.0
        createPriceBottomBorder.alpha = 0.0
        createUserAvatar.layer.borderWidth = 0.0
        var validationComplete:Bool = true
        
        if  createTitleTextField.text == nil || createTitleTextField.text?.count == 0 {
            createTitleBottomBorder.alpha = 1.0
            createTitleBottomBorder.backgroundColor = UIColor.red
            validationComplete =  false
        }
        if  createPriceTextField.text == nil || createPriceTextField.text?.count == 0 {
            createPriceBottomBorder.alpha = 1.0
            createPriceBottomBorder.backgroundColor  = UIColor.red
            validationComplete =  false
        }
        if selectedImage == nil{
           createUserAvatar.layer.borderWidth = 1.0
            createUserAvatar.layer.borderColor = UIColor.red.cgColor
            validationComplete =  false

        }
       
        return validationComplete
    }
    
    func resetCreateView() {
        createCurrencyBtn.setTitle(Utils.currenciesNames()[0], for: .normal)
        createTitleTextField.text = ""
        createPriceTextField.text = ""
        selectedCategoryIndex = 0
        selectedImage = nil
        createUserAvatar.image = UIImage(named: "Avatar")
        createTypeSegmentedControl.selectedSegmentIndex = 0
        
    }
    func createItemWithLocation(location:LocationItem){
        
        if let current = DataManager.shared().user {
            let itemData = [ "title" : createTitleTextField.text!, "price" :  createPriceTextField.text!,"currency" : currency, "type" : type, "category" : DataManager.shared().categories![selectedCategoryIndex],"latitude" :  String(format:"%f", location.coordinate!.latitude), "longitude" :  String(format:"%f", location.coordinate!.longitude), "locationName" : location.name, "ownerId" : current._id,"barterFor" : barterFor]
            NetworkingManager.shared().createItem(params: itemData, itemImage: selectedImage!, completion: { error, data in
                self.fetchItems()
                DispatchQueue.main.async {
                    self.createView.alpha = 0.0
                    self.didPressAdd(self.addBtn)
                    
                }
                
                
                
            })
            
            
        } else {
            print("no user")
        }
        
    
        

        
    }
    
    func fetchItems() {
        
        var dist:Float = -1.0
        if filter_distance != DataManager.shared().distances[0] {
            if filter_distance != DataManager.shared().distances[1] {
                dist = 3.0
            }
            if filter_distance != DataManager.shared().distances[2] {
                 dist = 10.0
            }
            if filter_distance != DataManager.shared().distances[3] {
                dist = 30.0
            }
        }
        NetworkingManager.shared().getItems(location: nil, distance: dist, completion: {error,data in
            
            if error == nil {
                DataManager.shared().loadItems(data:data)
                
                DispatchQueue.main.async {
                   
                    self.collectionView.reloadData()
                }
                
             
            }
        })
    }
    
    func updateTopView() {
        
        if let theUser = DataManager.shared().user {
            topViewUserNameLabel.text = theUser.name
            let urlStr = theUser.userAvatar
            if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
                topViewUserAvatar.kf.setImage(with: imageUrl) { result in
                    switch result {
                    case .success(let value):
                        self.topViewUserAvatar.image = value.image
                    case .failure(let error):
                        print("Error: \(error)")}
                }
            }
            
            
            
        }
        
        
        
    }
    
}
