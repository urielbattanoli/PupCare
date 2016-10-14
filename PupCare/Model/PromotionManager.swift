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
    
    static let sharedInstance = PromotionManager()
    
    func getPromotionsList(_ latitude: Float, longitude: Float, withinKilometers: Float, response: @escaping (_ promotions: [Promotion]?, _ error: NSError?) -> ()) {
        
        
        PFCloud.callFunction(inBackground: "getPromotionsList", withParameters: ["lat": latitude,"lng":longitude, "maxDistance":withinKilometers]) { (promotions, error) in
            
            var allPromotions: [Promotion] = []
            if let promotions = promotions as? [PFObject] {
                
                for promotion in promotions {
                    let object = Promotion(parseObject:promotion)
                    allPromotions.append(object)
                }
            }
            response(allPromotions, error as NSError?)
        }
    }
    
    
    
    func getPromotionDetails(_ promotion: Promotion, response: @escaping (_ promotionDetails: Promotion?, _ error: NSError?) -> ()) {
        
        let params = ["promoId" : promotion.objectId]
        
        PFCloud.callFunction(inBackground: "getPromotionDetails", withParameters: params) { (details, error) in
            
            promotion.products.removeAll()
            for product in (details as? [PFObject])! {
                if let petShopProduct = product["petShopProductId"] as? PFObject {
                    promotion.products.append(Product(parseObject: petShopProduct))
                }
            }
            response(promotion, error as NSError?)
        }
    }
}
