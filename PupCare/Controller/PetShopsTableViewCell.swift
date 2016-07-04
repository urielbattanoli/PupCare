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
    @IBOutlet weak var petShopNameLabel: UIStackView!
    @IBOutlet weak var petShopAddressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        petShopImageView.layer.masksToBounds = true
        petShopImageView.layer.cornerRadius = 10
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
