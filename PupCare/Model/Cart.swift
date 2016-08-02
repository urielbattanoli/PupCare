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
    var product: Product?
    var promotion: Promotion?
    var quantity: Int = 0
}

class CartProduct {
    var productList: Dictionary<String, [ProductCart]> = [:]
    
    subscript(s: String) -> [ProductCart]? {
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
    
    
    func addToCart(petShop: PetShop, product: Product?, promotion: Promotion?, quantity: Int) {

            
            for (pet, productCart) in Cart.sharedInstance.cartProduct.productList {
                if pet == petShop.objectId {
                    for (index, var productIn) in productCart.enumerate() {
                        
                        if let product = productIn.product {
                            if productIn.product!.isEqual(product) {
                                productIn.quantity = productIn.quantity + 1
                                Cart.sharedInstance.cartProduct.productList["\(petShop.objectId)"]?.removeAtIndex(index)
                                Cart.sharedInstance.cartProduct.productList["\(petShop.objectId)"]?.append(productIn)
                                return
                            }
                        }
                        if let promotion = productIn.promotion {
                            if productIn.promotion!.isEqual(promotion) {
                                productIn.quantity = productIn.quantity + 1
                                Cart.sharedInstance.cartProduct.productList["\(petShop.objectId)"]?.removeAtIndex(index)
                                Cart.sharedInstance.cartProduct.productList["\(petShop.objectId)"]?.append(productIn)
                                return
                            }
                        }
                    }
                }
            }
            
            
            // Percorre todos os profutos
//            for var productsFromPetShop in petShopProducts {
//                
//                // Se o item existe adiciona mais um na quantidade
//                if item.product == product!.objectId {
//                
//                    item.quantity = item.quantity + quantity
//                    break
//                }
//            }

//            if ja tem pet shop e n tem produto {
//                petShopProducts.append(ProductCart(petShop: petShop, product: product!, promotion: promotion!, quantity: 1))
//            }
            
            
            
            
//        }
//        else {
        
//            Cart.sharedInstance.cartProducts.setValue([ProductCart(petShop: petShop, product: product!, promotion: promotion!, quantity: 1)], forKey: petShop.objectId)
//            Cart.sharedInstance.cartProducts![petShop.objectId]!.append(ProductCart(petShop: petShop, product: product!, promotion: promotion!, quantity: 1))
            
            Cart.sharedInstance.cartProduct.productList[petShop.objectId] = [ProductCart(petShop: petShop, product: product, promotion: promotion, quantity: 1)]
            
            
//        }
        
        
        print(Cart.sharedInstance.cartProduct!)
    }
    
    
    
    func removeFromCart () {
        
    }
    
    
}
