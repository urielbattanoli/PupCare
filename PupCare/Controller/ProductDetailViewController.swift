//
//  ProductDetailViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    // Mark: Outlets
    @IBOutlet var carousel: iCarousel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var sliderQnt: UISlider!
    
    
    // Mark: Variables
    var product: Product?
    var petshop: PetShop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detalhes do produto"

        
        self.carousel.delegate = self
        self.carousel.dataSource = self
        self.carousel.type = .Rotary
        
        self.carousel.userInteractionEnabled = false
        
        
        if let product = self.product{
            self.lblName.text = product.name
            self.lblDescription.text = product.descript
        }
    }
    
    // Mark: iCarousel
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        if self.product != nil{
            return 1
        }
        return 0
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        var itemView: UIView
        
        if view == nil{
            itemView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 225))
            itemView.layer.borderWidth = 5
            itemView.layer.borderColor = UIColor(red: 115, green: 40, blue: 115).CGColor
            itemView.layer.cornerRadius = 10
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 185, height: 185))
            imageView.loadImage((self.product?.imageUrl)!)
            imageView.contentMode = .ScaleAspectFit
            imageView.layer.cornerRadius = 10
            
            itemView.addSubview(imageView)
        }
        else{
            itemView = view!
        }
        
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .Spacing{
            return value * 1.1
        }
        return value
    }

    @IBAction func AddToCartButton(sender: AnyObject) {
        Cart.sharedInstance.addToCart(self.petshop!, product: self.product, promotion: nil, quantity: 1)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}