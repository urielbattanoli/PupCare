//
//  PetShopsTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 6/30/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class PetShopsTableViewCell: UITableViewCell {

    @IBOutlet weak var petShopImageView: UIView!
    @IBOutlet weak var petShopNameLabel: UILabel!
    @IBOutlet weak var petShopAddressLabel: UILabel!
    
    var ranking: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        petShopImageView.layer.masksToBounds = true
        petShopImageView.layer.cornerRadius = 10
        
        
        for index in 0...ranking {
            self.viewWithTag(index)?.alpha = 1
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
