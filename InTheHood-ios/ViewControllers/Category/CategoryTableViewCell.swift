//
//  CategoryTableViewCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 31/10/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(category:String){
        categoryTitleLabel.text = category
        categoryImageView.image = UIImage(named: category)
    }

}
