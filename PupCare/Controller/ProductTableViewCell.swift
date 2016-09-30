//
//  ProductTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/30/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblQuant: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    //MARK: Variables
    var product: Product?{
        didSet{
            if let product = self.product{
                if self.photoImageView != nil{
                    self.photoImageView.loadImage(product.imageUrl)
                }
                if self.lblDescription != nil{
                    self.lblDescription.text = product.descript
                }
                
                self.lblName.text = product.name
                self.lblPrice.text = "Valor unitário: "+product.price.numberToPrice()
            }
        }
    }
    
    var promotion: Promotion?{
        didSet{
            if let promotion = self.promotion{
                
                if self.photoImageView != nil{
                    self.photoImageView.loadImage(promotion.promotionImage)
                }
                if self.lblDescription != nil{
                    self.lblDescription.text = promotion.promotionDescription
                }

                self.lblName.text = promotion.promotionName
                self.lblPrice.text = "Valor unitário: "+NSNumber(value: Double(promotion.newPrice) as Double).numberToPrice()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
