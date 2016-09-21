//
//  CartTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

protocol TransactionProtocol: class {
    func didFinishTransaction(_ message: String)
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

        
        var dick: [String: AnyObject] = [:]
        
        dick["orderId"] = "" as AnyObject?
        dick["petShop"] = petShop?.petShop
        dick["date"] = Date() as AnyObject?
        dick["price"] = petShop?.totalPrice as AnyObject?
        dick["trackId"] = "" as AnyObject?
        dick["shipment"] = 0 as AnyObject?
        dick["products"] = petShop!.productsInCart as? AnyObject
        dick["promotions"] = petShop!.promotionsInCart as? AnyObject
        
        let order = Order(data: dick)
        
        var cartao: [String: AnyObject] = [:]
        cartao["CardHolderName"] = "Rebecca Sommers" as AnyObject?
        cartao["CardNumber"] = "4012001038166662" as AnyObject?
        cartao["CVV"] = "456" as AnyObject?
        cartao["ExpirationYear"] = 2017 as AnyObject?
        cartao["ExpirationMonth"] = 04 as AnyObject?
        
        self.FinishOrderLoader.alpha = 1
        self.FinishOrderLoader.startAnimating()
        
        self.FinishOrderButton.isEnabled = false
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            OrderManager.sharedInstance.checkIfCardIsValid(cartao["CardNumber"] as! String) { (cardBrand) in
                cartao["CardBrand"] = cardBrand as AnyObject?
                
                OrderManager.sharedInstance.startTransaction(self.price, cardInfo: cartao, callback: { (message, trackId) in
                    
                    var data = [String:AnyObject]()
                    data["orderId"] = "" as AnyObject?
                    data["date"] = Date() as AnyObject?
                    data["trackId"] = trackId
                    data["price"] = self.price as AnyObject?
                    data["shipment"] = 10 as AnyObject?
                    data["petShop"] = self.petShop?.objectId as AnyObject?

                    OrderManager.sharedInstance.saveOrder(data, callback: { (orderId) in
                        
                        for product in (Cart.sharedInstance.cartDict.petShopList[self.petShop!.objectId]?.productsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["productId"] = product.product.objectId as AnyObject?
                            data["quantity"] = product.quantity as AnyObject?
                            data["price"] = product.product.price
                             
                            OrderManager.sharedInstance.saveProductsFromOrder(data)
                        }
                        
                        for promotion in (Cart.sharedInstance.cartDict.petShopList[self.petShop!.objectId]?.promotionsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["promotionId"] = promotion.promotion.objectId as AnyObject?
                            data["price"] = promotion.promotion.newPrice
                             as AnyObject?
                            OrderManager.sharedInstance.savePromotionsFromOrder(data)
                        }
                    })
                    
                    self.transactionDelegate?.didFinishTransaction(message)
                    
                    DispatchQueue.main.async{
                        self.FinishOrderButton.isEnabled = true
                        
                        self.FinishOrderLoader.alpha = 0.0
                        self.FinishOrderLoader.stopAnimating()
                        self.FinishOrderLoader.isHidden = true
                    }
                })
            }

        }
        
        self.transactionDelegate?.goToOrderResumeWithOrder(petShop!)
    }
}


