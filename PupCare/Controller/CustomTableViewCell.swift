//
//  CustomTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 9/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!

    @IBOutlet weak var finisheBt: BTNAttributedStyle!
    @IBOutlet weak var loaderBt: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
