//
//  ProductHeaderTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
