//
//  DetailsViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 31/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

extension DetailsViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
        
    }
}
extension DetailsViewController:UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIndex = row
        switch row {
        case 0:
            priceTextField.isHidden = true
            currencyBtn.isHidden = true
            barterTextView.isHidden = true
            midTitleLabel.isHidden = true

        case 1:
            priceTextField.isHidden = false
            currencyBtn.isHidden = false
            barterTextView.isHidden = true
            midTitleLabel.isHidden = false
        case 2:
            priceTextField.isHidden = true
            currencyBtn.isHidden = true
            barterTextView.isHidden = false
            midTitleLabel.isHidden = false

        default:
            break
        }
        
        
    }
}

class DetailsViewController: GeneralViewController {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    
    @IBOutlet weak var midTitleLabel: UILabel!
    @IBOutlet weak var typePickerView: UIPickerView!
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var barterTextView: UITextView!
    
    @IBOutlet weak var currencyBtn: UIButton!
    
    
    let titles = ["Donating", "Selling", "Bartering"]
    
    var selectedIndex = 0
    var category = ""

    var currency:String = Utils.currenciesNames()[0]

    override func viewDidLoad() {
        super.viewDidLoad()
        barterTextView.layer.cornerRadius = 15.0
        barterTextView.clipsToBounds = true
        barterTextView.layer.borderColor = UIColor.lightGray.cgColor
        barterTextView.layer.borderWidth = 1.0
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(backTapped))

        
        priceTextField.isHidden = true
        currencyBtn.isHidden = true
        barterTextView.isHidden = true
        midTitleLabel.isHidden = true
        
        self.title = category
        
        priceTextField.addDoneToolbar()
        
        priceTextField.addTarget(self, action: #selector(DetailsViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        itemTitleTextField.addTarget(self, action: #selector(DetailsViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        
        

    }
    
    @objc func nextTapped(){
        performSegue(withIdentifier: "imagesSelectionSegue", sender: self)

        
    }
    @objc func backTapped(){
           dismiss(animated: true, completion: nil)
    }
    
    
    func sellValidate()->Bool{
        if let t1 = itemTitleTextField.text {
                  if let t2 = priceTextField.text {
                      if t1.count > 0 && t2.count > 0 {
                          return true
                      }
                  }
              }
        return false
    }
    func donateValidate()->Bool{
           if let t1 = itemTitleTextField.text {
                         if t1.count > 0 {
                             return true
                         }
        }
           return false
       }
       func barterValidate()->Bool{
              if let t1 = itemTitleTextField.text {
                        if let t2 = barterTextView.text {
                            if t1.count > 0 && t2.count > 0 {
                                return true
                            }
                        }
                    }
              return false
          }
          
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = false

        switch selectedIndex {
            case 0:
                if  donateValidate(){
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
            case 1:
                if  sellValidate() {
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
            case 2:
                if  barterValidate() {
                    navigationItem.rightBarButtonItem?.isEnabled = true
                }
            default:
                break
        }
    }
    
    
    @IBAction func didPressCurrency(_ sender: Any) {
       
                 let alert = UIAlertController(title: "Currency", message: "Please Select an Option", preferredStyle: .actionSheet)
                 
                 alert.addAction(UIAlertAction(title:Utils.currenciesNames()[0] + " - " + Utils.currenciesStrings()[0], style: .default , handler:{ (UIAlertAction)in
                     self.currencyBtn.setTitle(Utils.currenciesNames()[0], for: .normal)
                     self.currency = Utils.currenciesNames()[0]
                 }))
                 
                 alert.addAction(UIAlertAction(title: Utils.currenciesNames()[1] + " - " + Utils.currenciesStrings()[1], style: .default , handler:{ (UIAlertAction)in
                     self.currencyBtn.setTitle(Utils.currenciesNames()[1], for: .normal)
                     self.currency = Utils.currenciesNames()[1]
                     
                     
                 }))
                 
                 alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
                     print("User click Dismiss button")
                 }))
                 
                 self.present(alert, animated: true, completion: {
                     
                 })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "imagesSelectionSegue" {
            let vc:ImageSelectionViewController = segue.destination as! ImageSelectionViewController
            vc.item_title = itemTitleTextField.text!
            vc.item_price = priceTextField.text ?? "0"
            vc.item_type = DataManager.shared().types[selectedIndex+1]
            vc.item_barterText = barterTextView.text ?? ""
            vc.item_category = category
            vc.item_currency = currency
        }
      
    }
    

}
