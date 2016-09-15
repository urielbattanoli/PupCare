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
        
        data["userId"] = parseObject.objectId as AnyObject?
        if let name = parseObject["name"] as? String{
            data["name"] = name as AnyObject?
        }
        if let photo = parseObject["image"] as? PFFile{
            data["photo"] = photo.url as AnyObject?
        }
        if let email = parseObject["email"] as? String{
            data["email"] = email as AnyObject?
        }
        self.init(data: data)
    }
}
