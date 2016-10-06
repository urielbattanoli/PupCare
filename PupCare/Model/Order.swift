//
//  Order.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/12/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class Order: NSObject {

    let orderId: String
    let petShop: PetShop
    let orderDate: Date
    let price: NSNumber
    let trackId: String
    let shipment: NSNumber
    var totalQuantity = 0
    let addressId: Address
    let paymentMethod: NSNumber
    
    var products: [Product] = []{
        didSet{
            var totalQuantity = 0
            for product in products{
                totalQuantity += product.stock.intValue
            }
            self.totalQuantity += totalQuantity
        }
    }
    var promotions: [Promotion] = []{
        didSet{
            var totalQuantity = 0
            for promotions in self.promotions{
                totalQuantity += promotions.stock.intValue
            }
            self.totalQuantity += totalQuantity
        }
    }
    
    init(data: [String : AnyObject]) {
        self.orderId = data["orderId"] as! String
        self.petShop = data["petShop"] as! PetShop
        self.orderDate = data["date"] as! Date
        self.price = data["price"] as! NSNumber
        self.trackId = data["trackId"] as! String
        self.shipment = data["shipment"] as! NSNumber
        self.addressId = data["addressId"] as! Address
        self.paymentMethod = data["paymentMethod"] as! NSNumber
    }
}
