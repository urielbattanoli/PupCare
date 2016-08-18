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
    @IBOutlet weak var containerView: UIView!
    
    var indexPath: NSIndexPath?
    
    var promotion: Promotion? {
        didSet {
            if let promotion = self.promotion {
            
                self.productNameLabel.text = promotion.promotionName
                self.oldPrice.text = NSNumber(float: promotion.lastPrice).numberToPrice()
                self.newPriceLabel.text = NSNumber(float: promotion.newPrice).numberToPrice()
                self.productDescriptionLabel.text = promotion.promotionDescription
                self.promotionPhoto.loadImage(promotion.promotionImage)
                
                self.discountPercentageLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2 / 2 * -1))
                self.discountPercentageLabel.text = "\(Double(100 - (100 * promotion.newPrice / promotion.lastPrice)).roundToPlaces(0))%"
                self.addToCartButton.addTarget(self, action: #selector(PromotionsTableViewCell.didPressAddToCart), forControlEvents: .TouchUpInside)
                self.addToCartButton.tag = indexPath!.row
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).CGColor
        self.containerView.layer.cornerRadius = 5
        
        self.addToCartButton.clipsToBounds = true
        self.addToCartButton.layer.cornerRadius = 5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 
    func didPressAddToCart() {
        
    
        Cart.sharedInstance.addToCart((self.promotion?.petshop)!, product: nil, promotion: self.promotion, quantity: 1)
        
    }
}

