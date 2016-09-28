//
//  ProductDetailViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Foundation

class ProductDetailViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    // Mark: Outlets
    @IBOutlet var carousel: iCarousel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var sliderQnt: UISlider!
    
    
    // Mark: Variables
    var product: Product?
    var petshop: PetShop?
    var CartDelegate: CartProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detalhes do produto"
        
        
        
        self.carousel.delegate = self
        self.carousel.dataSource = self
        self.carousel.type = .rotary
        
        self.carousel.isUserInteractionEnabled = false
        
        if let product = self.product{
            self.lblName.text = product.name
            self.lblDescription.text = product.descript
        }
        
        sliderQnt.configureSlider(minValue: 1, maxValue: 10, thumbImage: "oval", insideRetangle: "insideRetangle", outsideRetangle: "outsideRetangle")
        
        if let top = self.parent?.parent as? MainTabViewController {
            self.CartDelegate = top
        }
    }
    
//    func configureSlider(slider: UISlider) {
//        
//        let image = UIImage(named:"insideRetangle")
//        let myInsets : UIEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4)
//        
//        image?.resizableImage(withCapInsets: myInsets)
//        
//        slider.setMinimumTrackImage(image, for: UIControlState())
//        slider.setMaximumTrackImage(UIImage(named:"outsideRetangle"), for: UIControlState())
//        slider.setThumbImage(UIImage(named: "oval"), for: UIControlState())
//        slider.setThumbImage(UIImage(named: "oval"), for: UIControlState.highlighted)
//        
//        slider.maximumValue = 10
//        slider.minimumValue = 1
//        
//        slider.value = 1
//        
//    }
    
    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        
        let rounded = round(sender.value)
        
        sender.value = rounded
    }
    
//    
//    func addTextToImage(image: UIImage, text: String) -> UIImage {
//        let w = image.size.width
//        let h = image.size.height
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
//        var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!;
//        
//        var context: CGContextRef = CGBitmapContextCreate(nil, Int(w), Int(h), 8, 4*Int(w), colorSpace, CGImageAlphaInfo.NoneSkipFirst.rawValue)!
//        
//        CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage)
//        
//        let font = UIFont.systemFontOfSize(0.0)
//        let fontName = font.fontName as NSString
//        let cgFont = CGFontCreateWithFontName(fontName);
//        
//        let copiedFont = CGFontCreateCopyWithVariations(cgFont, nil)
//        
//        CGContextSetFont(context, copiedFont)
//        CGContextSetTextDrawingMode(context, .Fill)
//        CGContextSetRGBFillColor(context, 255, 255, 255, 1)
//        CGContextSetTextPosition(context, 3, 8)
//        
//        let imgCombined:CGImageRef = CGBitmapContextCreateImage(context)!
//        
//        let image = UIImage(CGImage: imgCombined)
//        
//        return image
//        
//        
//    }
    
    
    // Mark: iCarousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        if self.product != nil{
            return 1
        }
        return 0
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var itemView: UIView
        
        if view == nil{
            itemView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 225))
            itemView.layer.borderWidth = 2.5
            itemView.layer.borderColor = UIColor(red: 115, green: 40, blue: 115).cgColor
            itemView.layer.cornerRadius = 10
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 185, height: 185))
            imageView.loadImage((self.product?.imageUrl)!)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 10
            
            itemView.addSubview(imageView)
        }
        else{
            itemView = view!
        }
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing{
            return value * 1.1
        }
        return value
    }

    @IBAction func AddToCartButton(_ sender: AnyObject) {
        Cart.sharedInstance.addToCart(self.petshop!, product: self.product, promotion: nil, quantity: Int(sliderQnt.value))
        
        self.CartDelegate?.ShowCart()
        self.CartDelegate?.UpdateView(Cart.sharedInstance.getTotalItemsAndPrice())
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
