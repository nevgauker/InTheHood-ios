//
//  ItemViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 16/08/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import CropViewController
import LocationPickerViewController



enum ScreenType {
    case create
    case display
    case edit
}

extension ItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let categories = DataManager.shared().categories {
            return categories.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "CategoryCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
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
        return cell
    }
    
    
}
extension ItemViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedCategoryIndex = indexPath.item
            createCategoryCollectionView.reloadData()
            createCategoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}



extension ItemViewController:UITextFieldDelegate {
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


extension ItemViewController:CropViewControllerDelegate {
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

extension ItemViewController:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true , completion: {
            
            if let img = info[.originalImage] as? UIImage{
                
                self.presentCropViewController(img: img)
            }
            
            
        })
        
        
    }
}

extension ItemViewController:UINavigationControllerDelegate {
    
    
}





extension ItemViewController:UITextViewDelegate {
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


class ItemViewController: GeneralViewController {
    
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
    
    @IBOutlet weak var createCategoryCollectionView: CategoriesCollectionView!
    @IBOutlet weak var barterViewHeight: NSLayoutConstraint!
    
    //create
    var type:String = "Sell"
    var currency:String = Utils.currenciesNames()[0]
    var selectedCategoryIndex:Int = 0
    var barterFor = "" //create
    var selectedImage:UIImage?
    
    
    var screen:ScreenType = .create
    var item:Item?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenType()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var contentSize = createScrollView.contentSize
        contentSize.height = 1000
        contentSize.width = self.view.frame.size.width
        
        createScrollView.contentSize = contentSize
    }
    
    //MARK: actios
    @IBAction func didPressCreateyBtn(_ sender: UIButton) {
        
        
        if dataValidation() {
            
            if sender.tag == 0 ||  sender.tag == 1{
                let locationPicker = LocationPicker()
                locationPicker.pickCompletion = { (pickedLocationItem) in
                    
                    self.createItemWithLocation(location: pickedLocationItem)
                    // Do something with the location the user picked.
                }
                locationPicker.addBarButtons()
                // Call this method to add a done and a cancel button to navigation bar.
                
                let navigationController = UINavigationController(rootViewController: locationPicker)
                present(navigationController, animated: true, completion: nil)
            }else if sender.tag == 2 {
                //i want it
                
                performSegue(withIdentifier: "iwantitSegue", sender: self)
            }
           
            
            
        }
    }
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            self.updateViewConstraints()
            
        }else if sender.selectedSegmentIndex == 0 {
            type = "Sell"
            createCurrencyBtn.isEnabled = true
            createPriceTextField.isUserInteractionEnabled = true
            barterViewHeight.constant = 0.0
            self.updateViewConstraints()
            
        }else {
            type = "Barter"
            createCurrencyBtn.isEnabled = false
            createPriceTextField.text = "0"
            createPriceTextField.isUserInteractionEnabled = false
            barterViewHeight.constant = 120.0
            self.updateViewConstraints()
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
    
    
    //MARK: crop
    func presentCropViewController(img:UIImage) {
        DispatchQueue.main.async {
            let vc = CropViewController(croppingStyle: .default, image: img)
            vc.aspectRatioPreset = .presetSquare
            vc.delegate = self as CropViewControllerDelegate
            self.present(vc, animated: false, completion: nil)
        }
    }
    //MARK: data validation
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
    
    
    func createItemWithLocation(location:LocationItem){
        
        startLoader()
        
        if let current = DataManager.shared().user {
            let itemData = [ "title" : createTitleTextField.text!, "price" :  createPriceTextField.text!,"currency" : currency, "type" : type, "category" : DataManager.shared().categories![selectedCategoryIndex],"latitude" :  String(format:"%f", location.coordinate!.latitude), "longitude" :  String(format:"%f", location.coordinate!.longitude), "locationName" : location.name, "ownerId" : current._id,"barterFor" : barterFor]
            
            if screen == .edit {
                NetworkingManager.shared().updateItem(_id: self.item!._id, params: itemData, itemImage: selectedImage!, completion: { error, data in
                    self.stopLoader()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }else if screen == .create {
                
                NetworkingManager.shared().createItem(params: itemData, itemImage: selectedImage!, completion: { error, data in
                    self.stopLoader()
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }else {
                
                
            }
            
            
           
            
            
        } else {
            print("no user")
        }
    }

    
    
    func setScreenType() {
        if screen == .display || screen == .edit{
            if screen == .display  {
                createTitleTextField.isEnabled = false
                createPriceTextField.isEnabled = false
                createCurrencyBtn.isEnabled = false
                createCategoryCollectionView.isUserInteractionEnabled = false
                createTypeSegmentedControl.isEnabled = false
                createCreateBtn.setTitle("I want it!", for: .normal)
                createCreateBtn.tag = 2
                
                
            }
            if screen == .edit  {
                createCreateBtn.setTitle("Edit", for: .normal)
                createCreateBtn.tag = 1
            }
            if let obj = self.item {
                createTitleTextField.text = obj.title
                let type  = obj.type
                
                let cat = obj.category
                let index =  DataManager.shared().indexForCategory(category: cat)
                createCategoryCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
                
                if type == DataManager.shared().types[1] {
                    createTypeSegmentedControl.selectedSegmentIndex = 0
                }
                if type == DataManager.shared().types[2] {
                    createTypeSegmentedControl.selectedSegmentIndex = 1
                }
                if type == DataManager.shared().types[3] {
                    createTypeSegmentedControl.selectedSegmentIndex = 2

                }
                createPriceTextField.text = obj.price
                createCurrencyBtn.setTitle(obj.currency, for: .normal)
                if let theItem = self.item {
                    let urlStr = theItem.itemImage
                    if let imageUrl =  NetworkingManager.shared().getFullImageUrl(imageStr: urlStr){
                        createUserAvatar.kf.setImage(with: imageUrl) { result in
                            switch result {
                            case .success(let value):
                                self.selectedImage = value.image
                                self.createUserAvatar.image = self.selectedImage

                            case .failure(let error):
                                print("Error: \(error)")}
                        }
                    }

                    
                }
            }
            
        }
     
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "iwantitSegue" {
            let vc = segue.destination as! IWantItViewController
            if let obj = self.item {
                vc.item = obj
            }
            
        }
    }
    
   
}
