//
//  Cart.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/29/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

struct ProductCart {
    var petShop: PetShop
    var products: [Product] = []
    var promotions: [Promotion] = []
}

class CartProduct {
    var productList: Dictionary<String, ProductCart> = [:]
    
    subscript(s: String) -> ProductCart? {
        get {
            return productList[s]
        }
        set {
            productList[s] = newValue
        }
    }
    
}

class Cart: NSObject {
    
    static var sharedInstance = Cart()
    
    var cartProduct: CartProduct! = CartProduct()
    
    
    func addToCart(petShop: PetShop, product: Product?, promotion: Promotion?, quantity: Int) -> Int {
        
        
        for (pet, var productCart) in Cart.sharedInstance.cartProduct.productList {
            if pet == petShop.objectId {

                if productCart.products.contains(product!) {
                    return 1
                }
                
                if productCart.promotions.contains(promotion!) {
                    return 1
                }
                
                if let product = product {
                    
                    productCart.products.append(product)
                    
                    Cart.sharedInstance.cartProduct.productList["\(petShop.objectId)"]? = productCart
                    
                }
                if let promotion = promotion {
                    productCart.promotions.append(promotion)
                    Cart.sharedInstance.cartProduct.productList["\(petShop.objectId)"]? = productCart
                }
            }
        }
        
        print(Cart.sharedInstance.cartProduct!)
        return 0
    }
    
    func removeFromCart () {
        
    }
    
    
}
