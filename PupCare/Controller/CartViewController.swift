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
    
    // Finish Order
//    @IBOutlet weak var FinishOrderButton: UIButton!
//    @IBOutlet weak var FinishOrderItensCount: UILabel!
//    @IBOutlet weak var FinishOrderTotalPrice: UILabel!
//    @IBOutlet weak var FinishOrderQuantityLabel: UILabel!
//    @IBOutlet weak var FinishOrderPriceLabel: UILabel!
//    
//    
//    // Product
//    @IBOutlet weak var ProductValueLabel: UILabel!
//    @IBOutlet weak var ProductNameLabel: UILabel!
//    @IBOutlet weak var ProductPhotoImageView: UIImageView!
    
    
    // PetShop Details
    
    
//    @IBOutlet weak var PetShopAddressLabel: UILabel!
//    @IBOutlet weak var PetShopDistanceLabel: UILabel!
//    @IBOutlet weak var PetShopPhotoImageView: UIImageView!
    
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
        return sections[section].products.count + sections[section].promotions.count + 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CartTableViewCell
        
        
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("CartPetShop", forIndexPath: indexPath) as! CartTableViewCell
            
            // PetShop Details
            cell.PetShopNameLabel.textColor = Config.MainColors.GreyColor
            cell.PetShopDistanceLabel.textColor = Config.MainColors.GreyColor
            cell.PetShopPhotoImageView.layer.cornerRadius = 10
            cell.PetShopPhotoImageView.layer.masksToBounds = true
//
            cell.PetShopNameLabel.text = sections[indexPath.section].petShop.name
            cell.PetShopAddressLabel.textColor = Config.MainColors.GreyColor
            cell.PetShopAddressLabel.text = sections[indexPath.section].petShop.address
            break
        case indexPath.length:
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
            
            if indexPath.row - 1 < sections[indexPath.section].products.count {
                cell.ProductNameLabel.text = sections[indexPath.section].products[indexPath.row - 1].name
            } else {
                cell.ProductNameLabel.text = sections[indexPath.section].promotions[indexPath.row - 1].promotionName
            }
            
            cell.ProductNameLabel.textColor = Config.MainColors.GreyColor
            cell.ProductValueLabel.textColor = Config.MainColors.GreyColor
//            cell.ProductPhotoImageView.image = 
            
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
