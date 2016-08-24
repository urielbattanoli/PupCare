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
    
    var photos: [String] = []
    var promotion: Promotion?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        self.loadPromotion()
        
        carousel.delegate = self
        carousel.dataSource = self
        carousel.type = .Linear
        carousel.clipsToBounds = true
        
        self.view.clipsToBounds = true
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 0.5
        backgroundView.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).CGColor
        
    }
    
    func reloadDetails() {
        titleLabel.text = promotion!.promotionName
        subtitleLabel.text = promotion!.promotionDescription
        newPriceLabel.text = "Preço Atual: \(NSNumber(float: promotion!.newPrice).numberToPrice())"
        originalPriceLabel.text = "Preço Original: \(NSNumber(float: promotion!.lastPrice).numberToPrice())"
        
        for product in (promotion?.products)!  {
            self.photos.append(product.imageUrl)
        }
        if self.photos.count > 0 {
            self.carousel.reloadData()
        }
    }
    
    func loadPromotion() {
        PromotionManager.getPromotionDetails(promotion!) { (promotionDetails, error) in
            if error == nil {
                self.promotion = promotionDetails as Promotion!
                
                print("PROMO")
                print(self.promotion!)
                self.reloadDetails()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return photos.count
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
            imageView.loadImage(self.photos[index])
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
            return 1.0
        case .Spacing:
            return value * 1.1
        default:
            return value
        }
        
    }
}
