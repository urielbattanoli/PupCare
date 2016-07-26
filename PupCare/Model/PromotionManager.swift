//
//  PromotionManager.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

class PromotionManager: NSObject {
    
    static func getPromotionsList(latitude: Float, longitude: Float, withinKilometers: Float, response: (promotions: [Promotion]?, error: NSError?) -> ()) {
        
        
        PFCloud.callFunctionInBackground("getPromotionsList", withParameters: ["lat": latitude,"lng":longitude, "maxDistance":withinKilometers]) { (promotions, error) in
            
            var allPromotions: [Promotion] = []
            if let promotions = promotions as? [PFObject] {
                
                for promotion in promotions {
                    let object = Promotion(parseObject:promotion)
                    allPromotions.append(object)
                }
            }
            response(promotions: allPromotions, error: error)
        }
    }
    
    
    
    static func getPromotionDetails(promotion: Promotion, response: (promotionDetails: Promotion?, error: NSError?) -> ()) {
        
        let params = ["promoId" : promotion.objectId]
        
        PFCloud.callFunctionInBackground("getPromotionDetails", withParameters: params) { (details, error) in
            
            for product in (details as? [PFObject])! {
                if let petShopProduct = product["petShopProductId"] as? PFObject {
                    promotion.products.append(Product(parseObject: petShopProduct))
                }
            }
            response(promotionDetails: promotion, error: error)
        }
    }
}
