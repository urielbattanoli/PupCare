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
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(self.doubleValue))!
    }
}

extension UIImageView {
    func loadImage(_ url: String){
        self.kf_showIndicatorWhenLoading = true
        self.kf_setImageWithURL(URL(string: url)!)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(_ places:Int) -> Double {
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

extension Date {
    func dateToString() -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        
        return formatter.string(from: self)
    }
}

extension UIToolbar{
    func buttonDone(_ target: UIViewController, action: Selector){
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        self.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Pronto", style: UIBarButtonItemStyle.done, target: target, action: action)
        
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

