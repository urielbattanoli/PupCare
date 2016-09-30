//
//  PromotionDetailsViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Kingfisher
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class PromotionDetailsViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet var carousel: iCarousel!

    var promotion: Promotion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var AddToCartButton: UIButton!
    var CartDelegate: CartProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        
        
        
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .linear
        carousel.bounces = false
        carousel.clipsToBounds = true
        
        self.view.clipsToBounds = true
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 0.5
        backgroundView.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).cgColor
     
        self.AddToCartButton.clipsToBounds = true
        self.AddToCartButton.layer.cornerRadius = 5
        
        if let top = self.parent?.parent as? MainTabViewController {
            self.CartDelegate = top
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if promotion != nil {
            self.reloadDetails()
            self.reloadPhotos()
            
        } else {
            self.loadPromotion()
        }
    }
    
    fileprivate func reloadDetails() {
        titleLabel.text = promotion!.promotionName
        subtitleLabel.text = promotion!.promotionDescription
        newPriceLabel.text = "Preço Atual: \(NSNumber(value: promotion!.newPrice as Float).numberToPrice())"
        originalPriceLabel.text = "Preço Original: \(NSNumber(value: promotion!.lastPrice as Float).numberToPrice())"
        
    }
    
    
    fileprivate func reloadPhotos() -> Bool {
        
        self.carousel.reloadData()
        if self.promotion?.photos.count > 0 {
            self.carousel.reloadData()
            return true
        }
        
        PromotionManager.getPromotionDetails(promotion!, response: { (promotionDetails, error) in
            for product in promotionDetails!.products  {
                if !self.promotion!.photos.contains(product.imageUrl) {
                    self.promotion!.photos.append(product.imageUrl)
                }
            }
            self.carousel.reloadData()
        })
        
        return true
    }
    
    fileprivate func loadPromotion() {
        PromotionManager.getPromotionDetails(promotion!) { (promotionDetails, error) in
            if error == nil {
                self.promotion = promotionDetails as Promotion!
                self.reloadDetails()
                self.reloadPhotos()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return promotion!.photos.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //create new view if no view is available for recycling
        var itemView: UIView
        
        if view == nil{
            itemView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 225))
            itemView.layer.borderWidth = 2.5
            itemView.layer.borderColor = UIColor(red: 115, green: 40, blue: 115).cgColor
            itemView.layer.cornerRadius = 10
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 185, height: 185))
            imageView.loadImage(self.promotion!.photos[index])
            
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
        
        switch option {
        case .wrap:
            if self.promotion!.photos.count > 2 {
                return 1.0
            } else {
                return 0
            }
        case .spacing:
            return value * 1.1
    
        default:
            return value
        }
        
    }
    
    
    @IBAction func AddPromotionToCart(_ sender: AnyObject) {
        
        Cart.sharedInstance.addToCart((self.promotion?.petshop)!, product: nil, promotion: self.promotion, quantity: 1)
        CartDelegate?.ShowCart()
        CartDelegate?.UpdateView(Cart.sharedInstance.getTotalItemsAndPrice())
    }
    
    
}
