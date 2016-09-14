//
//  CartTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

protocol TransactionProtocol: class {
    func goToOrderResumeWithOrder(_ petShop: PetshopInCart)
}

class CartTableViewCell: UITableViewCell {
    
    var productInCart: ProductInCart?
    var promotionInCart: PromotionInCart?
    var petShop: PetShop?
    
    var petShopInCart: PetshopInCart?
    
    var tagTeste: Int?
    var itensCount: Int = 0
    var price: Double = 0.0
    var beganPrice: Double = 0.0
    var indexPath: Int = 0
    
    weak var transactionDelegate : TransactionProtocol?
    
    // Finish Order
    @IBOutlet weak var FinishOrderButton: UIButton!
    @IBOutlet weak var FinishOrderItensCount: UILabel!
    @IBOutlet weak var FinishOrderTotalPrice: UILabel!
    @IBOutlet weak var FinishOrderQuantityLabel: UILabel!
    @IBOutlet weak var FinishOrderPriceLabel: UILabel!
    @IBOutlet weak var FinishOrderLoader: UIActivityIndicatorView!
    
    
    // Product
    @IBOutlet weak var ProductValueLabel: UILabel!
    @IBOutlet weak var ProductNameLabel: UILabel!
    @IBOutlet weak var ProductPhotoImageView: UIImageView!
    @IBOutlet weak var ProductQuantitySlider: UISlider!
    @IBOutlet weak var ProductQuantity: UILabel!
    
    
    // PetShop Details
    @IBOutlet weak var PetShopNameLabel: UILabel!
    @IBOutlet weak var PetShopAddressLabel: UILabel!
    @IBOutlet weak var PetShopDistanceLabel: UILabel!
    @IBOutlet weak var PetShopPhotoImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func sliderChance(_ sender: UISlider) {
        let rounded = round(sender.value)
        
        sender.value = rounded
        
        self.ProductQuantity.text = "\(rounded)"
        
        if productInCart != nil {
            self.ProductValueLabel.text = "\(Float(productInCart!.product.price) * rounded)"
            self.productInCart?.quantity = Int(rounded)
            
            if let object = petShopInCart!.productsInCart.index(where: {$0.product == productInCart?.product}) {
                
                print(object)
            }
            
        }
        if promotionInCart != nil {
            self.ProductValueLabel.text = "\(Float(promotionInCart!.promotion.newPrice) * rounded)"
            self.promotionInCart?.quantity = Int(rounded)
        }
    }
    
    @IBAction func FinishPetShopOrder(_ sender: AnyObject) {
        let petShop = Cart.sharedInstance.cartDict.petShopList[(self.petShop!.objectId)]
        self.transactionDelegate?.goToOrderResumeWithOrder(petShop!)
    }
}


