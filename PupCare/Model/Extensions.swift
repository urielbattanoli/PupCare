//
//  Extensions.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

extension NSNumber{
    func stringPreco() -> String {
        let value = String(format: "%.2f", self.doubleValue)
        return "R$ \(value.stringByReplacingOccurrencesOfString(".", withString: ","))"
    }
}
