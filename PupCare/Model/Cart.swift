//
//  Cart.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/29/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

struct ProductInCart {
    var product: Product
    var quantity: Int
}

struct PromotionInCart {
    var promotion: Promotion
    var quantity: Int
}

class PetshopInCart {
    var petShop: PetShop?
    var productsInCart: [ProductInCart] = []
    var promotionsInCart: [PromotionInCart] = []
    var totalQuantity: Int = 0
    var totalPrice: Double = 0
    
    func updatePrice() {
        self.totalQuantity = 0
        self.totalPrice = 0
        
        for product in productsInCart {
            self.totalQuantity = self.totalQuantity + product.quantity
            self.totalPrice = self.totalPrice + Double(product.product.price) * Double(product.quantity)
        }
        for promotion in promotionsInCart {
            self.totalQuantity = self.totalQuantity + promotion.quantity
            self.totalPrice = self.totalPrice + Double(promotion.promotion.newPrice) * Double(promotion.quantity)
        }
    }
    
    func addProduct(_ product:Product, quantity: Int) {
        self.productsInCart.append(ProductInCart(product: product, quantity: quantity))
    }
    func addPromotion(_ promotion:Promotion, quantity: Int) {
        self.promotionsInCart.append(PromotionInCart(promotion: promotion, quantity: quantity))
    }
    
    func updateQuantity(_ product: ProductInCart?, promotion: PromotionInCart?, petShopId: String, newQuantity: Int) {
        
        
        if let product = product?.product {
            for (index, prod) in Cart.sharedInstance.cartDict.petShopList[petShopId]!.productsInCart.enumerated() {
                if prod.product.isEqual(product) {
                    Cart.sharedInstance.cartDict.petShopList[petShopId]!.productsInCart[index].quantity = newQuantity
                    Cart.sharedInstance.cartDict.petShopList[petShopId]!.updatePrice()
                    
                    if newQuantity == 0 {
                        Cart.sharedInstance.cartDict.petShopList[petShopId]!.productsInCart.remove(at: index)
                        
                        if Cart.sharedInstance.cartDict.petShopList[petShopId]!.totalQuantity == 0 {
                            Cart.sharedInstance.cartDict.petShopList.removeValue(forKey: petShopId)
                        }
                    }
                }
            }
        }
        
        if let promotion = promotion?.promotion {
            for (index, prod) in Cart.sharedInstance.cartDict.petShopList[petShopId]!.promotionsInCart.enumerated() {
                if prod.promotion.isEqual(promotion) {
                    Cart.sharedInstance.cartDict.petShopList[petShopId]!.promotionsInCart[index].quantity = newQuantity
                    Cart.sharedInstance.cartDict.petShopList[petShopId]!.updatePrice()
                    
                    if newQuantity == 0 {
                        Cart.sharedInstance.cartDict.petShopList[petShopId]!.promotionsInCart.remove(at: index)
                        
                        if Cart.sharedInstance.cartDict.petShopList[petShopId]!.totalQuantity == 0 {
                            Cart.sharedInstance.cartDict.petShopList.removeValue(forKey: petShopId)
                        }
                    }
                }
            }
        }
     
        
        
    }
    
    init() {
        
    }
    
}

class PetShopDict {
    var petShopList: Dictionary<String, PetshopInCart> = [:]
    
    subscript(s: String) -> PetshopInCart? {
        get {
            return petShopList[s]
        }
        set {
            petShopList[s] = newValue
        }
    }
    
}

class Cart: NSObject {
    
    static var sharedInstance = Cart()
    
    var cartDict: PetShopDict! = PetShopDict()
    
    func addToCart(_ petShop: PetShop, product: Product?, promotion: Promotion?, quantity: Int) -> Int {
        
       for (pet, cartDict) in Cart.sharedInstance.cartDict.petShopList {

            if pet == petShop.objectId {
                if let product = product {
                    for (index, var productInCart) in cartDict.productsInCart.enumerated() {
                        if product == productInCart.product {
                            productInCart.quantity = productInCart.quantity + quantity
                            
                            Cart.sharedInstance.cartDict.petShopList[pet]?.productsInCart[index] = productInCart
                            Cart.sharedInstance.cartDict.petShopList[pet]?.updatePrice()
                            return 1
                        }
                    }
                    Cart.sharedInstance.cartDict.petShopList[pet]?.productsInCart.append(ProductInCart(product: product, quantity: quantity))
                    Cart.sharedInstance.cartDict.petShopList[pet]?.updatePrice()
                    return 1
                }
                if let promotion = promotion {
                    
                    for (index, var promotionInCart) in cartDict.promotionsInCart.enumerated() {
                        if promotion == promotionInCart.promotion {
                            promotionInCart.quantity = promotionInCart.quantity + quantity
                            
                            Cart.sharedInstance.cartDict.petShopList[pet]?.promotionsInCart[index] = promotionInCart
                            Cart.sharedInstance.cartDict.petShopList[pet]?.updatePrice()
                            return 1
                        }
                    }
                    Cart.sharedInstance.cartDict.petShopList[pet]?.promotionsInCart.append(PromotionInCart(promotion: promotion, quantity: quantity))
                    Cart.sharedInstance.cartDict.petShopList[pet]?.updatePrice()
                    return 1
                }
            }
        }
        
        if let promotion = promotion {
            
            let newPetShop = PetshopInCart()
            newPetShop.petShop = petShop
            newPetShop.addPromotion(promotion, quantity: quantity)
            
            Cart.sharedInstance.cartDict.petShopList[petShop.objectId] = newPetShop
            Cart.sharedInstance.cartDict.petShopList[petShop.objectId]?.updatePrice()
        }
        
        if let product = product {
            
            let newPetShop = PetshopInCart()
            newPetShop.petShop = petShop
            newPetShop.addProduct(product, quantity: quantity)
        
            Cart.sharedInstance.cartDict.petShopList[petShop.objectId] = newPetShop
            Cart.sharedInstance.cartDict.petShopList[petShop.objectId]?.updatePrice()
        }
        return 0
    }
    
    func getTotalItemsAndPrice() -> (Int,Double) {
        var totalPrice: Double = 0
        var totalItems: Int = 0
        for petShop in Cart.sharedInstance.cartDict.petShopList {
            totalPrice = totalPrice + petShop.1.totalPrice
            totalItems = totalItems + petShop.1.totalQuantity
        }
        return (totalItems, totalPrice)
    }
    
    
    
    
}
