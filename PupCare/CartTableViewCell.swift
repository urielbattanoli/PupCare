//
//  CartTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    
    // Finish Order
    @IBOutlet weak var FinishOrderButton: UIButton!
    @IBOutlet weak var FinishOrderItensCount: UILabel!
    @IBOutlet weak var FinishOrderTotalPrice: UILabel!
    @IBOutlet weak var FinishOrderQuantityLabel: UILabel!
    @IBOutlet weak var FinishOrderPriceLabel: UILabel!
    
    
    // Product
    @IBOutlet weak var ProductValueLabel: UILabel!
    @IBOutlet weak var ProductNameLabel: UILabel!
    @IBOutlet weak var ProductPhotoImageView: UIImageView!
    
    
    // PetShop Details
    @IBOutlet weak var PetShopNameLabel: UILabel!
    @IBOutlet weak var PetShopAddressLabel: UILabel!
    @IBOutlet weak var PetShopDistanceLabel: UILabel!
    @IBOutlet weak var PetShopPhotoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Finish Order
        FinishOrderTotalPrice.textColor = Config.MainColors.GreyColor
        FinishOrderItensCount.textColor = Config.MainColors.GreyColor
        FinishOrderQuantityLabel.textColor = Config.MainColors.GreyColor
        FinishOrderPriceLabel.textColor = Config.MainColors.GreyColor
        FinishOrderButton.backgroundColor = Config.MainColors.BlueColor
        FinishOrderButton.layer.cornerRadius = 10
        
        
        // Product
        ProductValueLabel.tintColor = Config.MainColors.BlueColor
        
        
        // PetShop Details
        PetShopAddressLabel.textColor = Config.MainColors.GreyColor
        PetShopDistanceLabel.textColor = Config.MainColors.GreyColor
        PetShopPhotoImageView.layer.cornerRadius = 10
        PetShopPhotoImageView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func finishOrder(sender: AnyObject) {
        
    }
}
