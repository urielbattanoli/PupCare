//
//  UserParseExtension.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension User {

    convenience init(parseObject: PFUser) {
        var data = [String : AnyObject]()
        
        data["userId"] = parseObject["objectId"] as! String
        data["name"] = parseObject["name"] as! String
        data["photo"] = (parseObject["image"] as! PFFile).url
        
        self.init(data: data)
    }
}
