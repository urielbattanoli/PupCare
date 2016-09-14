//
//  CartTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

protocol TransactionProtocol: class {
    func didFinishTransaction(message: String)
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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func sliderChance(sender: UISlider) {
        let rounded = round(sender.value)
        
        sender.value = rounded
        
        self.ProductQuantity.text = "\(rounded)"
        
        if productInCart != nil {
            self.ProductValueLabel.text = "\(Float(productInCart!.product.price) * rounded)"
            self.productInCart?.quantity = Int(rounded)
            
            if let object = petShopInCart!.productsInCart.indexOf({$0.product == productInCart?.product}) {
                
                print(object)
            }
            
        }
        if promotionInCart != nil {
            self.ProductValueLabel.text = "\(Float(promotionInCart!.promotion.newPrice) * rounded)"
            self.promotionInCart?.quantity = Int(rounded)
        }
    }
    
    @IBAction func FinishPetShopOrder(sender: AnyObject) {
        let petShop = Cart.sharedInstance.cartDict.petShopList[(self.petShop!.objectId)]

        
        var dick: [String: AnyObject] = [:]
        
        dick["orderId"] = ""
        dick["petShop"] = petShop?.petShop
        dick["date"] = NSDate()
        dick["price"] = petShop?.totalPrice
        dick["trackId"] = ""
        dick["shipment"] = 0
        dick["products"] = petShop!.productsInCart as? AnyObject
        dick["promotions"] = petShop!.promotionsInCart as? AnyObject
        
        let order = Order(data: dick)
        
        var cartao: [String: AnyObject] = [:]
        cartao["CardHolderName"] = "Rebecca Sommers"
        cartao["CardNumber"] = "4012001038166662"
        cartao["CVV"] = "456"
        cartao["ExpirationYear"] = 2017
        cartao["ExpirationMonth"] = 04
        
        self.FinishOrderLoader.alpha = 1
        self.FinishOrderLoader.startAnimating()
        
        self.FinishOrderButton.enabled = false
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            OrderManager.sharedInstance.checkIfCardIsValid(cartao["CardNumber"] as! String) { (cardBrand) in
                cartao["CardBrand"] = cardBrand
                
                OrderManager.sharedInstance.startTransaction(self.price, cardInfo: cartao, callback: { (message, trackId) in
                    
                    var data = [String:AnyObject]()
                    data["orderId"] = ""
                    data["date"] = NSDate()
                    data["trackId"] = trackId
                    data["price"] = self.price
                    data["shipment"] = 10
                    data["petShop"] = self.petShop?.objectId

                    OrderManager.sharedInstance.saveOrder(data, callback: { (orderId) in
                        
                        for product in (Cart.sharedInstance.cartDict.petShopList[self.petShop!.objectId]?.productsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["productId"] = product.product.objectId
                            data["quantity"] = product.quantity
                            data["price"] = product.product.price
                             
                            OrderManager.sharedInstance.saveProductsFromOrder(data)
                        }
                        
                        for promotion in (Cart.sharedInstance.cartDict.petShopList[self.petShop!.objectId]?.promotionsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["promotionId"] = promotion.promotion.objectId
                            data["price"] = promotion.promotion.newPrice
                            
                            OrderManager.sharedInstance.savePromotionsFromOrder(data)
                        }
                    })
                    
                    self.transactionDelegate?.didFinishTransaction(message)
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.FinishOrderButton.enabled = true
                        
                        self.FinishOrderLoader.alpha = 0.0
                        self.FinishOrderLoader.stopAnimating()
                        self.FinishOrderLoader.hidden = true
                    }
                })
            }

        }
        
    }
}


