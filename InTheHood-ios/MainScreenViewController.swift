//
//  MainScreenViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 27/05/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import collection_view_layouts


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
        return categories.count
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
            theCell.categoryNamelabel.text = categories[indexPath.item]
        }
        
        return cell
    }
}

extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}



class MainScreenViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var filterView: UIView!

    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    let categories = ["aaaa", "abbb"]


    @IBOutlet weak var createScrollView: UIScrollView!
    
    @IBOutlet weak var createUserAvatar: UIImageView!
    
    @IBOutlet weak var createTitleTextField: UITextField!
    @IBOutlet weak var createTitleBottomBorder: UIView!
    @IBOutlet weak var createPriceBottomBorder: UIView!

    @IBOutlet weak var createCurrencyBtn: UIButton!
    @IBOutlet weak var createPriceTextField: UITextField!
    
    
    var last = 2

    var cellsSizes:[CGSize] = []
    
    
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


        
        
        let contentFlowLayout: ContentDynamicLayout = PinterestStyleFlowLayout()
        contentFlowLayout.delegate = self
        contentFlowLayout.contentPadding = ItemsPadding(horizontal: 0, vertical: 10)
        contentFlowLayout.cellsPadding = ItemsPadding(horizontal: 5, vertical: 5)
        contentFlowLayout.contentAlign = .left
        collectionView.collectionViewLayout = contentFlowLayout
        collectionView.reloadData()

        // Do any additional setup after loading the view.
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
    
    @IBAction func didPressCreateCurrencyBtn(_ sender: Any) {
    }
}
