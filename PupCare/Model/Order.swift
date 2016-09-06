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
    let orderDate: NSDate
    let price: NSNumber
    let trackId: String
    let shipment: NSNumber
    var totalQuantity = 0
    
    var products: [Product] = []{
        didSet{
            var totalQuantity = 0
            for product in products{
                totalQuantity += product.stock.integerValue
            }
            self.totalQuantity = totalQuantity
        }
    }
    
    init(data: [String : AnyObject]) {
        self.orderId = data["orderId"] as! String
        self.petShop = data["petShop"] as! PetShop
        self.orderDate = data["date"] as! NSDate
        self.price = data["price"] as! NSNumber
        self.trackId = data["trackId"] as! String
        self.shipment = data["shipment"] as! NSNumber
    }
}
