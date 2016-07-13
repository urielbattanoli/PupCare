//
//  Extensions.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Kingfisher

extension NSNumber{
    func stringPreco() -> String {
        let value = String(format: "%.2f", self.doubleValue)
        return "R$ \(value.stringByReplacingOccurrencesOfString(".", withString: ","))"
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