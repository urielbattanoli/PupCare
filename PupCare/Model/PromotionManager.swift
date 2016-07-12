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
    
    
    
    static func getPromotionDetails(promotionId: String, response: (promoionDetails: Promotion, error: NSError) -> ()) {
        
        let params = ["promoId" : promotionId]
        
        PFCloud.callFunctionInBackground("getPromotionDetails", withParameters: params) { (details, error) in
            var promotion = Promotion()
            if let details = details as? PFObject {
                promotion = Promotion(parseObject: details)
            }
            response(promoionDetails: promotion, error: error!)
        }
    }
}
