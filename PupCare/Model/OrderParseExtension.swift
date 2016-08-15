//
//  OrderParseExtension.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/12/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Parse

extension Order {

    convenience init(parseObject: PFObject) {
        let data: [String : AnyObject] = [:]
        
        self.init(data: data)
    }
}
