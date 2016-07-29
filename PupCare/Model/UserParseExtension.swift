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
        
        data["userId"] = parseObject.objectId
        if let name = parseObject["name"] as? String{
            data["name"] = name
        }
        if let photo = parseObject["image"] as? PFFile{
            data["photo"] = photo.url
        }
        if let email = parseObject["email"] as? String{
            data["email"] = email
        }
        self.init(data: data)
    }
}
