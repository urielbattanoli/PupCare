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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension String {
    func numberCardMask()-> String{
        var string = ""
        
            for i in 0..<self.characters.count{
                if i%4 == 0{
                    string += " "
                }
                if i<12{
                    string += "*"
                    continue
                }
                string += self.substringFromIndex(self.startIndex.advancedBy(i)).substringToIndex(self.startIndex.advancedBy(1))
            }
        
        
        return string
    }
    
    func brandCard() -> String{
        if self.characters.count>5{
            if self.hasPrefix("438935") || self.hasPrefix("451416") || self.hasPrefix("504175") || self.hasPrefix("5067") || self.hasPrefix("4576") || self.hasPrefix("4011") || self.hasPrefix("506699"){
                return "elo"
            }
            else if self.hasPrefix("4"){
                return "visa"
            }
            else if self.hasPrefix("5"){
                return "master"
            }
            else {
                return "invalidCard"
            }
        }
        return ""
    }
}