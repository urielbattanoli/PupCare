//
//  PromotionsTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class PromotionsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var petShopLabel: UILabel!
    @IBOutlet weak var promotionPhoto: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var promotionColor = UIColor(red: 84/255, green: 199/255, blue: 252/255, alpha: 1)
    
    var promotion: Promotion? {
        didSet{
            if let promotion = self.promotion {
             
                self.productNameLabel.text = promotion.promotionName
                //self.priceLabel.text = promotion.newPrice
                
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addToCartButton.clipsToBounds = true
        self.addToCartButton.layer.cornerRadius = 5
        self.addToCartButton.backgroundColor = promotionColor
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
