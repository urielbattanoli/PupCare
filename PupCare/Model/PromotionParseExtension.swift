//
//  PromotionParseExtension.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/7/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Promotion {
    convenience init (parseObject: PFObject) {
        
        var data = [String: AnyObject]()
        let promotion = parseObject["Promotion"] as! PFObject
        
        data["lastPrice"] = promotion["lastPrice"] as! Float
        data["newPrice"] = promotion["newPrice"] as! Float
        data["initialDate"] = promotion["initialDate"] as! String
        data["finalDate"] = promotion["finalDate"] as! String
        
        self.init(data: data)
    }
}
