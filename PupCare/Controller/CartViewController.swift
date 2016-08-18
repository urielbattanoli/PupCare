//
//  CartViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartViewCellDelegate {
    
    @IBOutlet weak var CartTableView: UITableView!
    
    
    var sections: [ProductCart] = []
    var endedPrice: Float = 0.0
    var beganPrice: Float = 0.0
    var beganSliding: Int = 1
    var endedSliding: Int = 0
    
    var workingCell: CartTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CartTableView.delegate = self
        self.CartTableView.dataSource = self
        
        
        for (_, productCart) in Cart.sharedInstance.cartProduct.productList {
            sections.append(productCart)
        }
        
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
            
            cell.tagTeste = indexPath.section
            
            break
        case lenght:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CartConfirmation", forIndexPath: indexPath) as! CartTableViewCell
            
            cell.delegate = self
            
            cell.FinishOrderButton.backgroundColor = Config.MainColors.BlueColor
            cell.FinishOrderButton.layer.cornerRadius = 5
            cell.FinishOrderButton.layer.masksToBounds = true
            
            cell.FinishOrderPriceLabel.textColor = Config.MainColors.GreyColor
            cell.FinishOrderTotalPrice.textColor = Config.MainColors.GreyColor
            cell.FinishOrderItensCount.textColor = Config.MainColors.GreyColor
            cell.FinishOrderQuantityLabel.textColor = Config.MainColors.GreyColor
            
            cell.FinishOrderPriceLabel.text = "\(self.beganPrice)"
            cell.beganPrice = self.beganPrice
            cell.price = self.beganPrice
            
            var thisSection = sections[indexPath.section]
            
            let itensCount = thisSection.products.count + thisSection.promotions.count
            cell.FinishOrderQuantityLabel.text = "\(itensCount)"
            cell.itensCount = itensCount
            
            cell.tag = indexPath.section + 10
            
            print("TAG \(cell.tag)")
            
            break
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("CartProduct", forIndexPath: indexPath) as! CartTableViewCell
            
            if indexPath.row <= sections[indexPath.section].products.count {
                
                let product = sections[indexPath.section].products[indexPath.row - 1]
                cell.product = sections[indexPath.section].products[indexPath.row - 1]
                cell.ProductPhotoImageView.loadImage(product.imageUrl)
                cell.ProductValueLabel.text = "\(product.price)"
                cell.ProductNameLabel.text = product.name
                cell.price = Float(product.price)
                
            } else {
                
                let promotion = sections[indexPath.section].promotions[indexPath.row - 1 -
                    sections[indexPath.section].products.count]
                cell.ProductNameLabel.text = promotion.promotionName
                cell.ProductValueLabel.text = "\(promotion.newPrice)"
                cell.ProductPhotoImageView.loadImage(promotion.promotionImage)
                cell.price = promotion.newPrice
                cell.promotion = promotion
                
            }
            
            self.beganPrice = self.beganPrice + (Float(beganSliding) * cell.price)
            cell.ProductNameLabel.textColor = Config.MainColors.GreyColor
            cell.ProductValueLabel.textColor = Config.MainColors.GreyColor
            cell.ProductQuantity.textColor = Config.MainColors.GreyColor
            cell.ProductQuantitySlider.tag = indexPath.section + 100
            cell.tagTeste = indexPath.section
            
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CartViewController.tableViewTap))
            gestureRecognizer.cancelsTouchesInView = false
            cell.ProductQuantitySlider.addGestureRecognizer(gestureRecognizer)
            
        
            
            break
        }
        
        
        cell.indexPath = indexPath.row
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func cellSliderDidChange(cell: CartTableViewCell) {
        print("DELEGATE:")
        print(cell.FinishOrderQuantityLabel.text)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("INDEX PATH\(indexPath.row)")
    }
    
    func tableViewTap (tapGesture: UIPanGestureRecognizer) {

        let point: CGPoint = tapGesture.locationInView(self.CartTableView)
        let indexPath = self.CartTableView.indexPathForRowAtPoint(point)
        if indexPath == nil {
            print("TAPPED OUTSIDE CELL")
        } else {
            
            let cell = self.CartTableView.cellForRowAtIndexPath(indexPath!)
            if let cell = cell as? CartTableViewCell {
//                print("TAPPED CELL\(cell.price)")
                self.workingCell = cell
                
            }
        }
    }
    
    
    @IBAction func SliderValueChanged(sender: UISlider, forEvent event: UIEvent) {
        let allTouches = event.allTouches()
        
        if let finishCell = self.view.viewWithTag(sender.tag - 90) as? CartTableViewCell {
            if allTouches?.count > 0 {

                
                let phase = (allTouches?.first as UITouch!).phase
                if phase == UITouchPhase.Began {
                    
                    let a = Int(round(sender.value))
                    if a != 0 {
                        beganSliding = a
                        beganPrice = finishCell.beganPrice
                    }
                }
                if phase == UITouchPhase.Ended {
                    endedSliding = Int(round(sender.value))
                    
                    print("ENDED SLIDING: \(endedSliding)")
                    print("BEGAN SLIDING: \(beganSliding)")
                    
                    if endedSliding > beganSliding {
                        
                        finishCell.itensCount = finishCell.itensCount + (endedSliding - beganSliding)
                        finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"

                    } else if endedSliding < beganSliding {
                        if endedSliding == 0 && beganSliding >= 1 {
                            alertRemovedItem({ (shouldRemoveItem) in
                                if shouldRemoveItem {
                                    self.CartTableView.deleteRowsAtIndexPaths([self.CartTableView.indexPathForCell(finishCell)!], withRowAnimation: UITableViewRowAnimation.Fade)
                                    
                                }
                            })
                        } else {
                            finishCell.itensCount = finishCell.itensCount - (beganSliding - endedSliding)
                            finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"
                        }
                    }
                    
                    if let workingCell = workingCell {
                        finishCell.price = finishCell.price - (Float(beganSliding) * workingCell.price) + (Float(endedSliding) * workingCell.price)
                        
                        finishCell.FinishOrderPriceLabel.text = "\(finishCell.price)"
                    }
                }
            }
        }
    }
    
    func alertRemovedItem(shouldRemoveItem: (Bool) -> Void) {
        let alert = UIAlertController(title: "Carrinho", message: "Deseja remover este item do carrinho?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .Default , handler: { action in
            print("Deletou")
            shouldRemoveItem(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .Cancel , handler: { action in
            print("Cancelou")
            shouldRemoveItem(false)
        }))
            
            
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
