//
//  PromotionDetailsViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
import Kingfisher

class PromotionDetailsViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    @IBOutlet var carousel: iCarousel!

    var promotion: Promotion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var AddToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        
        
        
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .Linear
        carousel.clipsToBounds = true
        
        self.view.clipsToBounds = true
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 0.5
        backgroundView.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).CGColor
     
        self.AddToCartButton.clipsToBounds = true
        self.AddToCartButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        if promotion != nil {
            self.reloadDetails()
            self.reloadPhotos()
            
        } else {
            self.loadPromotion()
        }
    }
    
    private func reloadDetails() {
        titleLabel.text = promotion!.promotionName
        subtitleLabel.text = promotion!.promotionDescription
        newPriceLabel.text = "Preço Atual: \(NSNumber(float: promotion!.newPrice).numberToPrice())"
        originalPriceLabel.text = "Preço Original: \(NSNumber(float: promotion!.lastPrice).numberToPrice())"
        
    }
    
    
    private func reloadPhotos() -> Bool {
        
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
    
    private func loadPromotion() {
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
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return promotion!.photos.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        //create new view if no view is available for recycling
        var itemView: UIView
        
        if view == nil{
            itemView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 225))
            itemView.layer.borderWidth = 2.5
            itemView.layer.borderColor = UIColor(red: 115, green: 40, blue: 115).CGColor
            itemView.layer.cornerRadius = 10
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 185, height: 185))
            imageView.loadImage(self.promotion!.photos[index])
            
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
        
        switch option {
        case .Wrap:
            if self.promotion!.photos.count > 1 {
                return 1.0
            } else {
                return 0
            }
        case .Spacing:
            return value * 1.1
        default:
            return value
        }
        
    }
    
    
    @IBAction func AddPromotionToCart(sender: AnyObject) {
        
        Cart.sharedInstance.addToCart((self.promotion?.petshop)!, product: nil, promotion: self.promotion, quantity: 1)
    }
    
    
}
