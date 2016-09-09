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
                if self.lblQuant != nil{
                    self.lblQuant.text = "\(product.stock)"
                }
                if self.lblTotal != nil{
                    self.lblTotal.text = NSNumber(double: (product.price.doubleValue * product.stock.doubleValue)).numberToPrice()
                }
                
                self.lblName.text = product.name
                self.lblPrice.text = product.price.numberToPrice()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
