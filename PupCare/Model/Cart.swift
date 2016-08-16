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

                
                if let product = product {
                    
                    if productCart.products.contains(product) {
                        return 1
                    }
                    
                    productCart.products.append(product)
                    
                    Cart.sharedInstance.cartProduct.productList[petShop.objectId]? = productCart
                    return 1
                }
                if let promotion = promotion {
                    if productCart.promotions.contains(promotion) {
                        return 1
                    }
                    
                    productCart.promotions.append(promotion)
                    Cart.sharedInstance.cartProduct.productList[petShop.objectId]? = productCart
                    return 1
                }
            }
        }
        
        if let promotion = promotion {
            let newPetShop = ProductCart(petShop: petShop, products: [], promotions: [promotion])
            Cart.sharedInstance.cartProduct.productList[petShop.objectId] = newPetShop
        }
        
        if let product = product {
            let newPetShop = ProductCart(petShop: petShop, products: [product], promotions: [])
            Cart.sharedInstance.cartProduct.productList[petShop.objectId] = newPetShop
        }
        
        print(Cart.sharedInstance.cartProduct!)
        
        if Cart.sharedInstance.cartProduct.productList.count > 0 {
            Cart.sharedInstance.showCartView()
        }
        
        return 0
    }
    
    func removeFromCart () {
        
    }
    
    func showCartView() {
//        var tab: UITabBarController = UITabBarController()
//        var cgrect = CGRectMake(tab.tabBar.frame.size.height , tab.tabBar.frame.size.height, tab.tabBar.frame.size.width, 40)
//        
//        var view = UIView(frame: cgrect)
//        view.backgroundColor = UIColor.redColor()
//        
//        UIApplication.sharedApplication().keyWindow?.addSubview(view)
    }
    
    
    
}
