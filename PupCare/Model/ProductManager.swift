//
//  ProductManager.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/4/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class ProductManager: NSObject {
    
    func getProductList(petShopId: String, block: ([Product])->()) {
        let params = ["petShopId" : petShopId]
        print(petShopId)
        PFCloud.callFunctionInBackground("getProductList", withParameters: params) { (objects, error) in
            var products = [Product]()
            if let error = error{
                print(error)
                block(products)
            }
            else{
                if let objects = objects as? [PFObject]{
                    for object in objects{
                        products.append(Product(parseObject: object))
                    }
                    block(products)
                }
            }
        }
    }
}
