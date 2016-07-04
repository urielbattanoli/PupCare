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
    @IBOutlet weak var lblBrand: UILabel!
    
    //MARK: Variables
    var product: Product?{
        didSet{
            if let product = self.product{
//                self.photoImageView.image = 
                self.lblName.text = product.name
                self.lblDescription.text = product.descript
                self.lblPrice.text = "\(product.price)"
                self.lblBrand.text = product.brand
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
