//
//  Extensions.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

extension NSNumber {
    func numberToPrice() -> String {
        
        let formatter = NSNumberFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.numberStyle = .CurrencyStyle
        
        return formatter.stringFromNumber(self.doubleValue)!
    }
}

extension UIImageView {
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
        return "**** **** **** \(self)"
    }
}

extension NSDate {
    func dateToString() -> String{
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.dateStyle = .ShortStyle
        
        return formatter.stringFromDate(self)
    }
}

extension UIToolbar{
    func buttonDone(target: UIViewController, action: Selector){
        self.frame = CGRectMake(0, 0, 320, 50)
        self.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Pronto", style: UIBarButtonItemStyle.Done, target: target, action: action)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        self.items = items
        self.sizeToFit()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

