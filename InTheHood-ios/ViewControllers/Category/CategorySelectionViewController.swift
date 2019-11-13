//
//  CategorySelectionViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 31/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit


enum Screen_type:String {
    case filter
    case creation
    
}



protocol didSelectCategory {
    func didSelect(category:String)
}

extension CategorySelectionViewController:UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let categories  = DataManager.shared().categories {
            if  self.screen_type.rawValue == Screen_type.filter.rawValue {
                     return categories.count
                 }
                 return categories.count-1
        }
        return 0
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        if let categories = DataManager.shared().categories {
            
              if  self.screen_type.rawValue == Screen_type.filter.rawValue {
                    cell.setData(category: categories[indexPath.row])
              }else {
                cell.setData(category: categories[indexPath.row+1])
            }
            
        }
        return cell
    }
    
}

extension CategorySelectionViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            if let categories = DataManager.shared().categories {
                if let del = self.delegate {
                    if self.screen_type.rawValue == Screen_type.creation.rawValue {
                        del.didSelect(category: categories[indexPath.row+1])
                    }else {
                        del.didSelect(category: categories[indexPath.row])

                    }
                }
            }
        })
    }
}

class CategorySelectionViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var screen_type:Screen_type = Screen_type.filter
    
    
    var delegate:didSelectCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
