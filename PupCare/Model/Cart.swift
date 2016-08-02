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
    var product: Product
    var quantity: Int = 0
}

class CartProduct {
    var cartProducts: Dictionary<String, [ProductCart]> = [:]
    
    subscript(s: String) -> [ProductCart]? {
        get {
            return cartProducts[s]
        }
        set {
            cartProducts[s] = newValue
        }
    }
}

class Cart: NSObject {
    
    static var sharedInstance = Cart()
    
    var cartProducts: CartProduct? = CartProduct()
    
    
    func addToCart(petShop: PetShop, product: Product, quantity: Int) {
        var array = Cart.sharedInstance.cartProducts![petShop.objectId]
        
        // Unrwap nos produtos Cart
        if var array = array! as? [ProductCart] {
            
            // Percorre todos os profutos
            for var item in array {
                
                // Se o item existe adiciona mais um na quantidade
                if item.product == product.objectId {
                
                    item.quantity = item.quantity + quantity
                }
            }
            
            array.append(ProductCart(petShop: petShop, product: product, quantity: 1))
            
        }
        else {
            Cart.sharedInstance.cartProducts![petShop.objectId]?.append(ProductCart(petShop: petShop, product: product, quantity: quantity))
        }
        
        
    }
    
    func removeFromCart () {
        
    }
    
    
}
