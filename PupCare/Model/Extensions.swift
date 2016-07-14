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

extension UIView{
    func botCorners(radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.TopLeft , .TopRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        
        self.layer.mask = mask
    }
    
    func topCorners(radius: CGFloat){
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.BottomLeft , .BottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        
        self.layer.mask = mask
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}