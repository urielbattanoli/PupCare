//
//  Extensions.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

extension NSNumber {
    func numberToPrice() -> String {
        
        let formatter = NSNumberFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.numberStyle = .CurrencyStyle
        
        return formatter.stringFromNumber(self.doubleValue)!
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}