//
//  ImageSelectionViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 31/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import CropViewController
import LocationPickerViewController



extension ImageSelectionViewController:UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    
        self.dismiss(animated: true , completion: {
            
            if let img = info[.originalImage] as? UIImage{
                
                self.presentCropViewController(img: img)
            }
            
            
        })
        
        
    }
}

extension ImageSelectionViewController:UINavigationControllerDelegate {
    
    
}


extension ImageSelectionViewController:CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int){
        
        
        var cropImage : UIImage?

           if image.size.width > 800 || image.size.height > 800
           {
               cropImage = Utils.imageWithImage(image: image, scaledToSize: CGSize(width: 800.0, height: 800.0))
           }
           else{
               cropImage = image
           }
        
        
        
        self.navigationController?.popViewController(animated: true)
                    DispatchQueue.main.async {
        
                        if self.updateIndex == 0 {
                            self.mainImageView.image = cropImage
                            self.selectedImage = cropImage
                        }
                        if self.updateIndex == 1 {
                            self.smallImageView1.image = cropImage

                        }
                        if self.updateIndex == 2 {
                            self.smallImageView2.image = cropImage
                        }
                        if self.updateIndex == 3 {
                            self.smallImageView3.image = cropImage
                        }
                        if self.dataValidation() {
                            self.navigationItem.rightBarButtonItem?.isEnabled = true

                        }
        }
        
        

    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
    
}



class ImageSelectionViewController: GeneralViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var smallImageView1: UIImageView!
    @IBOutlet weak var smallImageView2: UIImageView!
    @IBOutlet weak var smallImageView3: UIImageView!
    
    var selectedImage:UIImage?

    var item_price = "0"
    var item_title = ""
    var item_barterText = ""
    var item_currency = ""
    var item_type = ""
    var item_category = ""
    var updateIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
               navigationItem.rightBarButtonItem?.tintColor = .black
               navigationItem.rightBarButtonItem?.isEnabled = false
    }
    

    
    @objc func nextTapped(){
        let locationPicker = LocationPicker()
        locationPicker.pickCompletion = { (pickedLocationItem) in
                          self.createItemWithLocation(location: pickedLocationItem)
        }
        
        self.navigationController?.pushViewController(locationPicker, animated: true)

    }
    
    
    
    @IBAction func didPresscreateImageSelectionBtn(_ sender: UIButton) {
        updateIndex = sender.tag
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
    
    
    
    //MARK: crop
     func presentCropViewController(img:UIImage) {
         DispatchQueue.main.async {
             let vc = CropViewController(croppingStyle: .default, image: img)
             vc.aspectRatioPreset = .presetSquare
             vc.delegate = self as CropViewControllerDelegate
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
           //  self.present(vc, animated: false, completion: nil)
         }
     }
    
    
    
    
    func dataValidation()->Bool{
        return mainImageView.image != nil
    }
    
    func createItemWithLocation(location:LocationItem){
           
           startLoader()
           
           if let current = DataManager.shared().user {
            let itemData = [ "title" : item_title, "price" :  item_price,"currency" : item_currency, "type" : item_type, "category" : item_category,"latitude" :  String(format:"%f", location.coordinate!.latitude), "longitude" :  String(format:"%f", location.coordinate!.longitude), "locationName" : location.name, "ownerId" : current._id,"barterFor" : item_barterText]
               
                   
            NetworkingManager.shared().createItem(params: itemData, itemImage: self.selectedImage!, completion: { error, data in
                       self.stopLoader()
                       DispatchQueue.main.async {
                           self.dismiss(animated: true, completion: nil)
                       }
            })
           } else {
               print("no user")
           }
       }

}
