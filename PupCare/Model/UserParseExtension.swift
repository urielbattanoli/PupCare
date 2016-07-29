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
        data["name"] = "Uriel"//parseObject["name"]
        data["photo"] = "https://fbcdn-sphotos-a-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-9/22729_821076457975277_2327804208051810931_n.jpg?oh=83e9880b20bfc33edef54519ac7a0d63&oe=581E79BC&__gda__=1478920913_427a33f9384913158ce855a3962b5997"//(parseObject["image"] as! PFFile).url
        
        self.init(data: data)
    }
}
