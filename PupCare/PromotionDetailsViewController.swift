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

    var photos: [UIImage] = []
    var promotion: Promotion?
//    var promotionColor = Config.MainColors.BlueColor
    var downloader: ImageDownloader! = ImageDownloader(name: "downloadPromotionImages")
    
    
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
        
//        newPriceLabel.textColor = UIColor(CGColor: promotionColor.CGColor)
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 5
        backgroundView.layer.borderWidth = 0.5
        backgroundView.layer.borderColor = Config.MainColors.BorderColor.CGColor
    
    }
    
    func reloadDetails() {
        titleLabel.text = promotion!.promotionName
        subtitleLabel.text = promotion!.promotionDescription
        newPriceLabel.text = "Preço Atual: \(NSNumber(float: promotion!.newPrice).numberToPrice())"
        originalPriceLabel.text = "Preço Original: \(NSNumber(float: promotion!.lastPrice).numberToPrice())"
        
        let group = dispatch_group_create()
        
        for product in (promotion?.products)!  {

            if let url = NSURL(string: product.imageUrl) {
                dispatch_group_enter(group)
                self.downloader.downloadImageWithURL(url, options: .None, progressBlock: { (receivedSize, totalSize) -> () in
                    
                    }, completionHandler:{(image,error,imageURL,data) -> () in
                        if image != nil {
                            self.photos.append(image!)
                        }
                        dispatch_group_leave(group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            if self.photos.count > 0 {
                self.carousel.reloadData()
            }
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
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:225, height:225))
            itemView.image = photos[index]
            itemView.layer.borderWidth = 5
            itemView.layer.borderColor = UIColor(red: 115, green: 40, blue: 115).CGColor
            itemView.layer.cornerRadius = 10
            itemView.contentMode = UIViewContentMode.ScaleAspectFit
        }
        else
        {
            itemView = view as! UIImageView;
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

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
