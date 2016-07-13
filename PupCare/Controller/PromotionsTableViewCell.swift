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
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    
    var promotionColor = UIColor(red: 84/255, green: 199/255, blue: 252/255, alpha: 1)
    var oldPriceColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
    
    var promotion: Promotion? {
        didSet{
            if let promotion = self.promotion {
                
//                let formatter = NSNumberFormatter()
//                formatter.locale = NSLocale.currentLocale()
//                formatter.numberStyle = .CurrencyStyle
                
                self.productNameLabel.text = promotion.promotionName
                self.oldPrice.text = NSNumber(float: promotion.lastPrice).numberToPrice()
                self.newPriceLabel.text = NSNumber(float: promotion.newPrice).numberToPrice()
                self.productDescriptionLabel.text = promotion.promotionDescription
                self.newPriceLabel.textColor = promotionColor
                self.oldPrice.textColor = oldPriceColor
                
                self.discountPercentageLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 / 2 * -1))
                self.discountPercentageLabel.text = "\(Double(100 - (100 * promotion.newPrice / promotion.lastPrice)).roundToPlaces(2))%"
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

