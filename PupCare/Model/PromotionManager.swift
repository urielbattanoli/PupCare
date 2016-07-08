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

    static func getNearbyPromotions(latitude: Float, longitude: Float, withinKilometers: Float, response: (promotions: [Promotion]?, error: NSError?) -> ()) {
        
        let currentLocation = PFGeoPoint(latitude: 10, longitude: 10)
        
        PFCloud.callFunctionInBackground("getPromotions", withParameters: ["currentLocation": currentLocation]) { (promotions, error) in
            var result: [Promotion] = []
            if let promotions = promotions as? [PFObject] {
                
                for promotion in promotions {
                    let object = Promotion(parseObject:promotion)
                    result.append(object)
                }
            }
            response(promotions: result, error: error)
        }
    }
}
