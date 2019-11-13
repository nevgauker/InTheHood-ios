//
//  LocationTableViewCell.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 06/11/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
