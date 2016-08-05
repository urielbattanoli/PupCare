//
//  CardParseExtension.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/3/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Card {

    convenience init(parseObject: PFObject) {
        var data = [String: AnyObject]()
        
        data["number"] = parseObject["number"] as! String
        data["expirationDate"] = parseObject["expirationDate"] as! String
        data["name"] = parseObject["name"] as! String
        
        self.init(data: data)
    }
}
