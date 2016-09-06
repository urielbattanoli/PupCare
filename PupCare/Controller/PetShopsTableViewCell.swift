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
    
    var ranking: Int = 0{
        didSet{
            for index in 0...self.ranking {
                self.viewWithTag(index)?.alpha = 1
            }
        }
    }
    
    var petShop: PetShop?{
        didSet{
            if let petShop = self.petShop{
                self.petShopNameLabel.text = petShop.name
                self.petShopAddressLabel.text = petShop.address
                self.petShopImageView.loadImage(petShop.imageUrl)
                if let location = UserManager.sharedInstance.getLocationToSearch(){
                    self.petShopDistanceLabel.text = "\((petShop.location.distanceFromLocation(location)/1000).roundToPlaces(2)) km"
                }
                self.ranking = Int(petShop.ranking)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if self.petShopRoundedView != nil {
            self.petShopRoundedView.layer.cornerRadius = 10
            self.petShopRoundedView.layer.borderWidth = 0.5
            self.petShopRoundedView.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).CGColor
            self.petShopRoundedView.clipsToBounds = true
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
