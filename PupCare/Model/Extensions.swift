//
//  Extensions.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Kingfisher

extension NSNumber {
    func numberToPrice() -> String {
        
        let formatter = NSNumberFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.numberStyle = .CurrencyStyle
        
        return formatter.stringFromNumber(self.doubleValue)!
    }
}

extension UIImageView{
    func loadImage(url: String){
        self.kf_showIndicatorWhenLoading = true
        self.kf_setImageWithURL(NSURL(string: url)!)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}