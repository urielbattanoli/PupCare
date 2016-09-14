//
//  CartViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TransactionProtocol {
    
    @IBOutlet weak var CartTableView: UITableView!
    
    
    var sections: [PetshopInCart] = []
    var endedPrice: Double = 0.0
    var beganPrice: Double = 0.0
    var beganSliding: Int = 1
    var endedSliding: Int = 0
    var workingCell: CartTableViewCell?
    
    var CartDelegate: CartProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CartTableView.delegate = self
        self.CartTableView.dataSource = self
        
        for (_, petShop) in Cart.sharedInstance.cartDict.petShopList {
            sections.append(petShop)
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let view = storyBoard.instantiateViewControllerWithIdentifier("MainTabIdentifier") as? MainTabViewController {
            
            self.CartDelegate = view
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itensCount = sections[section].productsInCart.count + sections[section].promotionsInCart.count + 2
        if (itensCount > 2) {
            return (sections[section].productsInCart.count + sections[section].promotionsInCart.count + 2)
        } else {
            if (sections.count == 1) {
//                self.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: {
                    self.CartDelegate?.HideCart()
                })
                return 0
            } else {
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CartTableViewCell
        
        let lenght = sections[indexPath.section].productsInCart.count + sections[indexPath.section].promotionsInCart.count + 1
        
        switch indexPath.row {
        case 0:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CartPetShop", forIndexPath: indexPath) as! CartTableViewCell
            
            let petShop = sections[indexPath.section].petShop
            cell.PetShopPhotoImageView.loadImage(petShop!.imageUrl)
            cell.PetShopPhotoImageView.layer.masksToBounds = true
            cell.PetShopPhotoImageView.layer.cornerRadius = 10
            cell.PetShopAddressLabel.text = petShop!.address
            cell.PetShopNameLabel.text = petShop!.name
            cell.tagTeste = indexPath.section
            
            break
        case lenght:
            
            cell = tableView.dequeueReusableCellWithIdentifier("CartConfirmation", forIndexPath: indexPath) as! CartTableViewCell
            
            let thisSection = sections[indexPath.section]
            cell.FinishOrderButton.layer.cornerRadius = 5
            cell.FinishOrderButton.layer.masksToBounds = true
            cell.FinishOrderPriceLabel.text = "\(thisSection.totalPrice)"
            cell.beganPrice = thisSection.totalPrice
            cell.price = thisSection.totalPrice
            
            let itensCount = thisSection.totalQuantity
            cell.FinishOrderQuantityLabel.text = "\(thisSection.totalQuantity)"
            cell.itensCount = itensCount
            
            cell.transactionDelegate = self
            
            cell.petShop = thisSection.petShop
            cell.tag = indexPath.section + 10
            
        
            cell.FinishOrderButton.setTitle("Finalizar compra para esta Pet Shop", forState: UIControlState.Normal)
            cell.FinishOrderButton.setTitle("", forState: UIControlState.Disabled)
            
            print("TAG \(cell.tag)")
            
            break
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("CartProduct", forIndexPath: indexPath) as! CartTableViewCell
            let section = sections[indexPath.section]
            
            
            if indexPath.row <= section.productsInCart.count {
                
                let productInCart = section.productsInCart[indexPath.row - 1]
                cell.productInCart = productInCart
                cell.ProductPhotoImageView.loadImage(productInCart.product.imageUrl)
                cell.ProductValueLabel.text = "\(Double(productInCart.product.price) * Double(productInCart.quantity))"
                cell.ProductQuantitySlider.value = Float(productInCart.quantity)
                cell.ProductQuantity.text = "\(productInCart.quantity)"
                cell.ProductNameLabel.text = productInCart.product.name
                cell.price = Double(productInCart.product.price)
                cell.beganPrice = Double(productInCart.product.price)
                
            } else {
                
                let productsCount: Int = section.productsInCart.count
                let promotionInCart = section.promotionsInCart[indexPath.row - 1 - productsCount]
                cell.ProductNameLabel.text = promotionInCart.promotion.promotionName
                cell.ProductValueLabel.text = "\(Double(promotionInCart.promotion.newPrice) * Double(promotionInCart.quantity))"
                cell.ProductQuantitySlider.value = Float(promotionInCart.quantity)
                cell.ProductQuantity.text = "\(promotionInCart.quantity)"
                cell.ProductPhotoImageView.loadImage(promotionInCart.promotion.promotionImage)
                cell.price = Double(promotionInCart.promotion.newPrice)
                cell.beganPrice = Double(promotionInCart.promotion.newPrice)
                cell.promotionInCart = promotionInCart
                
            }
            
            self.beganPrice = self.beganPrice + (Double(beganSliding) * cell.price)
            cell.ProductQuantitySlider.tag = indexPath.section + 100
            
            cell.tagTeste = indexPath.section
            cell.petShopInCart = section
            
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
    
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func SliderValueChanged(sender: UISlider, forEvent event: UIEvent) {
        let allTouches = event.allTouches()
        
        if let finishCell = self.view.viewWithTag(sender.tag - 90) as? CartTableViewCell {
            if allTouches?.count > 0 {
                
                let phase = (allTouches?.first as UITouch!).phase
                
                // GUARDA VALORES INICIAIS
                if phase == UITouchPhase.Began {
                    let a = Int(round(sender.value))
                    if a != 0 {
                        beganSliding = a
                        beganPrice = finishCell.beganPrice
                    }
                }
                
                // TERMINOU DE MEXER NO SLIDER
                if phase == UITouchPhase.Ended {
                    endedSliding = Int(round(sender.value))
                    print("ENDED SLIDING: \(endedSliding)")
                    print("BEGAN SLIDING: \(beganSliding)")
                    
                    // AUMENTOU VALOR NO SLIDER
                    if endedSliding > beganSliding {
                        finishCell.itensCount = finishCell.itensCount + (endedSliding - beganSliding)
                        finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"
                        
                        if let workingCell = workingCell {
                            finishCell.price = finishCell.price - (Double(beganSliding) * workingCell.price) + (Double(endedSliding) * workingCell.price)
                            finishCell.FinishOrderPriceLabel.text = "\(finishCell.price)"
                            
                            
                            let object = workingCell.petShopInCart!.petShop!.objectId
                            
                                Cart.sharedInstance.cartDict.petShopList[object]?.updateQuantity(workingCell.productInCart, promotion: workingCell.promotionInCart, petShopId: object, newQuantity: endedSliding)
                        }
                        
                        // DIMINUIU VALOR NO SLIDER
                    } else if endedSliding < beganSliding {
                        // VALOR MENOR QUE O MINIMO
                        if endedSliding == 0 && beganSliding >= 1 {
                            
                            if finishCell.itensCount > 0 {
                                finishCell.price = finishCell.price - (Double(beganSliding) * workingCell!.price)
                                finishCell.FinishOrderPriceLabel.text = "\(finishCell.price)"
                                
                                finishCell.itensCount = finishCell.itensCount - (beganSliding - endedSliding)
                                finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"
                            }
                            alertRemovedItem({ (shouldRemoveItem) in
                                if shouldRemoveItem {
//                                 print("REMOVE ITEM FROM CART")
                                    let object = self.workingCell!.petShopInCart!.petShop!.objectId
                                    
                                    Cart.sharedInstance.cartDict.petShopList[object]?.updateQuantity(self.workingCell!.productInCart, promotion: self.workingCell!.promotionInCart, petShopId: object, newQuantity: self.endedSliding)
                                    
                                    self.CartTableView.reloadData()

                                } else {
                                    
                                    self.workingCell!.itensCount = 1
                                    self.workingCell!.ProductQuantity.text = "\(self.workingCell!.itensCount)"
                                    self.workingCell!.ProductValueLabel.text = "\(self.workingCell!.beganPrice)"
                                    
                                    finishCell.price = finishCell.price + self.workingCell!.price
                                    finishCell.FinishOrderPriceLabel.text = "\(finishCell.price)"
                                    
                                    finishCell.itensCount = finishCell.itensCount + 1
                                    finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"
                                    
                                    sender.value = 1
                                    
                                    let object = self.workingCell!.petShopInCart!.petShop!.objectId
                                    
                                    Cart.sharedInstance.cartDict.petShopList[object]?.updateQuantity(self.workingCell!.productInCart, promotion: self.workingCell!.promotionInCart, petShopId: object, newQuantity: 1)
                                    
                                }
                            })
                            
                            // APENAS DIMINUIU
                        } else {
                            
                            finishCell.itensCount = finishCell.itensCount - (beganSliding - endedSliding)
                            finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"
                            
                            if let workingCell = workingCell {
                                finishCell.price = finishCell.price - (Double(beganSliding) * workingCell.price) + (Double(endedSliding) * workingCell.price)
                                
                                finishCell.FinishOrderPriceLabel.text = "\(finishCell.price)"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didFinishTransaction(message: String) {
        print(message)
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        switch message {
        case "Captured":
            alert.title = "Pagamento Efetuado"
            alert.message = "Sua compra foi realizada com sucesso, aguarde a entrega."
            alert.addAction(UIAlertAction(title: "Ir para Meus Pedidos", style: .Cancel, handler: { (action) in
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.tabBarController?.selectedIndex = 2
            }))
            alert.addAction(UIAlertAction(title: "Voltar ao Carrinho", style: .Default, handler: { (action) in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
        case "Voided":
            alert.title = "Falha no Pagamento"
            alert.message = "Ocorreu algum problema na hora de confirmar o pagamento. Revise seus dados"
            alert.addAction(UIAlertAction(title: "Voltar ao Carrinho", style: .Cancel, handler: { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
        default:
            break
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
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
