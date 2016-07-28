//
//  PetShopsTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 6/30/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class PetShopsTableViewCell: UITableViewCell {

    @IBOutlet weak var petShopImageView: UIImageView!
    @IBOutlet weak var petShopNameLabel: UILabel!
    @IBOutlet weak var petShopAddressLabel: UILabel!
    @IBOutlet weak var petShopDistanceLabel: UILabel!
    @IBOutlet weak var petShopView: UIView!
    @IBOutlet weak var petShopContentView: UIView!
    @IBOutlet weak var petShopRoundedView: UIView!
    
    var ranking: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        petShopRoundedView.layer.cornerRadius = 10
        petShopRoundedView.layer.borderWidth = Config.BorderWidth
        petShopRoundedView.layer.borderColor = Config.MainColors.BorderColor
        petShopRoundedView.clipsToBounds = true

        for index in 0...ranking {
            self.viewWithTag(index)?.alpha = 1
        }
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
