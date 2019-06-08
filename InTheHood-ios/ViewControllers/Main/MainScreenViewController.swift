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

extension MainScreenViewController:CropViewControllerDelegate {
    
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
        return CGSize(width: 100.0, height: 45.0)
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
extension MainScreenViewController: ContentDynamicLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.row]
    }
}

extension MainScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return cellsSizes.count
        }
        
        if let categories = NetworkingManager.shared().categories {
            return categories.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var identifier = "itemCell"
        if last == 2 {
            last = 1
        }else {
            last = 2
        }
        
        identifier +=  String(last)
        if  collectionView.tag == 1 {
            identifier = "CategoryCell"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if  collectionView.tag == 1 {
            let theCell = cell as! CategoryCell
            if let categories = NetworkingManager.shared().categories {
                theCell.categoryNamelabel.text = categories[indexPath.item]
                if indexPath.item == self.selectedCategoryIndex {
                   theCell.backgroundColor = Utils.fillColor()
                    theCell.categoryNamelabel.textColor = UIColor.white
                }else {
                    theCell.backgroundColor = UIColor.white
                    theCell.categoryNamelabel.textColor = UIColor.black

                }
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
    
    
    var last = 2

    var cellsSizes:[CGSize] = []
    
    
    //create
    var selectedImage:UIImage?
    var type:String = "Sell"
    var currency:String = Utils.currenciesStrings()[0]
    var selectedCategoryIndex:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size1 = CGSize(width: self.view.frame.size.width/2, height: 322)
        let size2 = CGSize(width: self.view.frame.size.width/2, height: 258)
        let size3 = CGSize(width: self.view.frame.size.width/2, height: 258)
        let size4 = CGSize(width: self.view.frame.size.width/2, height: 322)
        
        cellsSizes.append(size1)
        cellsSizes.append(size2)
        cellsSizes.append(size3)
        cellsSizes.append(size4)
        

        
    NetworkingManager.shared().getItems(location: [ "longitude" :"-1", "latitude" : "-1" ], distance:  -1)
        

        
      
        let contentFlowLayout: ContentDynamicLayout = PinterestStyleFlowLayout()
        contentFlowLayout.delegate = self
        contentFlowLayout.contentPadding = ItemsPadding(horizontal: 0, vertical: 10)
        contentFlowLayout.cellsPadding = ItemsPadding(horizontal: 5, vertical: 5)
        contentFlowLayout.contentAlign = .left
        collectionView.collectionViewLayout = contentFlowLayout
        collectionView.reloadData()
        
        createUserAvatar.layer.cornerRadius = createUserAvatar.frame.size.width / 2
        createCreateBtn.layer.cornerRadius = 15.0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var contentSize = createScrollView.contentSize
        contentSize.height = 2000
        createScrollView.contentSize = contentSize
        
    }
    //MARK: - actions
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
                self.filterView.alpha = 1.0
                self.filterBtn.setTitle("CANCEL", for: .normal)
                
            }, completion: { (finished: Bool) in
                self.filterBtn.backgroundColor = UIColor.red
                self.filterBtn.setTitleColor(UIColor.white, for: .normal)
                
            })
            addBtn.isEnabled = false
            
            
        }else {sender.tag = 0
            
            addBtn.isEnabled = true
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.filterView.alpha = 0.0
                self.filterBtn.setTitle("FILTER", for: .normal)
            }, completion: { (finished: Bool) in
                self.filterBtn.backgroundColor = UIColor.white
                self.filterBtn.setTitleColor(UIColor(red: 82.0/255.0, green: 145.0/255.0, blue: 255.0/255.0, alpha: 1.0), for: .normal)
            })
            
        }
        
        
        
    }
    @IBAction func didPressCreateyBtn(_ sender: Any) {
        
        
        if dataValidation() {
            createView.alpha = 0.0
            performSegue(withIdentifier: "locationPickerSegue", sender: self)
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
            let vc = CropViewController(croppingStyle: .circular, image: img)
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
    
    
}
