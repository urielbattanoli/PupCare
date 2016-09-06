//
//  CustomTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 9/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLbl: UILabel!
    @IBOutlet weak var rigthLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
