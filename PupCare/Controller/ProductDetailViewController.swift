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
    @IBOutlet weak var TableViewConstraint: NSLayoutConstraint!
    
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
        carousel.bounces = false
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        checkCart()
    }
    
    //MARK: Adjust Constraints
    func checkCart() {
        if Cart.sharedInstance.cartDict.petShopList.count > 0 { //.getTotalItemsAndPrice().0 > 0 {
            adjustConstraintsForCart()
        } else {
            adjustConstraintsToHideCart()
        }
    }
    
    func adjustConstraintsForCart() {
        self.TableViewConstraint.constant = 75
    }
    
    func adjustConstraintsToHideCart() {
        self.TableViewConstraint.constant = 0
    }

    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        
        let rounded = round(sender.value)
        
        sender.value = rounded
    }
    
    
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
        if option == .spacing {
            return value * 1.1
        }
        return value
    }

    @IBAction func AddToCartButton(_ sender: AnyObject) {
        Cart.sharedInstance.addToCart(self.petshop!, product: self.product, promotion: nil, quantity: Int(sliderQnt.value))
        
        self.CartDelegate?.ShowCart()
        self.CartDelegate?.UpdateView(Cart.sharedInstance.getTotalItemsAndPrice())
        checkCart()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
