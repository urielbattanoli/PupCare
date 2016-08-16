//
//  CartViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var CartTableView: UITableView!
    
    
    var sections: [ProductCart] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CartTableView.delegate = self
        self.CartTableView.dataSource = self
        
        for (_, productCart) in Cart.sharedInstance.cartProduct.productList {
            sections.append(productCart)
        }
        
        print(sections)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sections[section].products.count + sections[section].promotions.count + 2)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CartTableViewCell
        
        print("CURRENT ROW\(indexPath.row)")
        let lenght = sections[indexPath.section].products.count + sections[indexPath.section].promotions.count + 1
        
        switch indexPath.row {
        case 0:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CartPetShop", forIndexPath: indexPath) as! CartTableViewCell
            
            let petShop = sections[indexPath.section].petShop
            cell.PetShopPhotoImageView.loadImage(petShop.imageUrl)
            cell.PetShopPhotoImageView.layer.masksToBounds = true
            cell.PetShopPhotoImageView.layer.cornerRadius = 10
            
            cell.PetShopDistanceLabel.textColor = Config.MainColors.GreyColor
            cell.PetShopAddressLabel.textColor = Config.MainColors.GreyColor
            cell.PetShopNameLabel.textColor = Config.MainColors.GreyColor
            cell.PetShopAddressLabel.text = petShop.address
            cell.PetShopNameLabel.text = petShop.name
            
            break
        case lenght:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CartConfirmation", forIndexPath: indexPath) as! CartTableViewCell
            cell.FinishOrderButton.backgroundColor = Config.MainColors.BlueColor
            cell.FinishOrderButton.layer.cornerRadius = 5
            cell.FinishOrderButton.layer.masksToBounds = true

            cell.FinishOrderPriceLabel.textColor = Config.MainColors.GreyColor
            cell.FinishOrderTotalPrice.textColor = Config.MainColors.GreyColor
            cell.FinishOrderItensCount.textColor = Config.MainColors.GreyColor
            cell.FinishOrderQuantityLabel.textColor = Config.MainColors.GreyColor
            
            break
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("CartProduct", forIndexPath: indexPath) as! CartTableViewCell
            
            if indexPath.row <= sections[indexPath.section].products.count {
                
                let product = sections[indexPath.section].products[indexPath.row - 1]
                cell.product = sections[indexPath.section].products[indexPath.row - 1]
                cell.ProductPhotoImageView.loadImage(product.imageUrl)
                cell.ProductValueLabel.text = "\(product.price)"
                cell.ProductNameLabel.text = product.name
                
            } else {
                
                let promotion = sections[indexPath.section].promotions[indexPath.row - 1 -
                    sections[indexPath.section].products.count]
                cell.ProductNameLabel.text = promotion.promotionName
                cell.ProductValueLabel.text = "\(promotion.lastPrice)"
                cell.ProductPhotoImageView.loadImage(promotion.promotionImage)
                cell.promotion = promotion
            }
            
            cell.ProductNameLabel.textColor = Config.MainColors.GreyColor
            cell.ProductValueLabel.textColor = Config.MainColors.GreyColor
            cell.ProductQuantity.textColor = Config.MainColors.GreyColor
            
            
            break
        }
        
        print(sections[indexPath.section])
        print("INDEX PATH: \(indexPath.row)")
        
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
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
