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
        
        return formatter.string(from: NSNumber(value : self.doubleValue))!

    }
}

extension UIImageView {
    func loadImage(_ url: String){
        let urlToKf = URL(string: url)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: urlToKf, placeholder: nil, options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)

    }
}

extension Float {
    /// Rounds the double to decimal places value

    mutating func roundToPlaces(_ places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        
        var mult = self * divisor
        mult = mult / divisor
        
        return roundf(Float(mult))
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

extension UISlider {
    func configureSlider (minValue: Float, maxValue: Float, thumbImage: String, insideRetangle: String, outsideRetangle: String) {
        let image = UIImage(named: insideRetangle)
        let myInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4)
        
        image?.resizableImage(withCapInsets: myInsets)
        
        self.setMinimumTrackImage(image, for: UIControlState())
        self.setMaximumTrackImage(UIImage(named: outsideRetangle), for: UIControlState())
        self.setThumbImage(UIImage(named: thumbImage), for: UIControlState())
        self.setThumbImage(UIImage(named: thumbImage), for: UIControlState.highlighted)
        
        self.maximumValue = maxValue
        self.minimumValue = minValue
        
        self.value = 1
    }
}

extension Notification.Name {
    static let whenDidFinishOrder = Notification.Name("NEWORDERFINISHED")
}
