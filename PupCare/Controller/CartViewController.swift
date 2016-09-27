//
//  CartViewController.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
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

enum DismissDelegateOptions {
    case CartEmpty
    case UpdateCart
}



class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TransactionProtocol {
    
    @IBOutlet weak var CartTableView: UITableView!
    
    
    var sections: [PetshopInCart] = []
    var endedPrice: Double = 0.0
    var beganPrice: Double = 0.0
    var beganSliding: Int = 1
    var endedSliding: Int = 0
    var workingCell: CartTableViewCell?
    
    var CartDelegate: CartProtocol?
    var CartDismissDelegate: DismissProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CartTableView.delegate = self
        self.CartTableView.dataSource = self
        
        
        
        for (_, petShop) in Cart.sharedInstance.cartDict.petShopList {
            sections.append(petShop)
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        if let view = storyBoard.instantiateViewController(withIdentifier: "MainTabIdentifier") as? MainTabViewController {
            
            self.CartDelegate = view
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itensCount = sections[section].productsInCart.count + sections[section].promotionsInCart.count + 2
        if (itensCount > 2) {
            return (sections[section].productsInCart.count + sections[section].promotionsInCart.count + 2)
        } else {
            if (sections.count == 1) {
                self.CartDismissDelegate?.DidDismiss(option: .CartEmpty)
                return 0
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: CartTableViewCell
        
        let lenght = sections[(indexPath as NSIndexPath).section].productsInCart.count + sections[(indexPath as NSIndexPath).section].promotionsInCart.count + 1
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CartPetShop", for: indexPath) as! CartTableViewCell
            
            let petShop = sections[(indexPath as NSIndexPath).section].petShop
            cell.PetShopPhotoImageView.loadImage(petShop!.imageUrl)
            cell.PetShopPhotoImageView.layer.masksToBounds = true
            cell.PetShopPhotoImageView.layer.cornerRadius = 10
            cell.PetShopAddressLabel.text = petShop!.address
            cell.PetShopNameLabel.text = petShop!.name
            cell.tagTeste = (indexPath as NSIndexPath).section
            
            break
        case lenght:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CartConfirmation", for: indexPath) as! CartTableViewCell
            
            let thisSection = sections[(indexPath as NSIndexPath).section]
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
            cell.tag = (indexPath as NSIndexPath).section + 10
            
        
            cell.FinishOrderButton.setTitle("Finalizar compra para esta Pet Shop", for: UIControlState())
            cell.FinishOrderButton.setTitle("", for: UIControlState.disabled)
            
            print("TAG \(cell.tag)")
            
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "CartProduct", for: indexPath) as! CartTableViewCell
            let section = sections[(indexPath as NSIndexPath).section]
            
            
            if (indexPath as NSIndexPath).row <= section.productsInCart.count {
                
                let productInCart = section.productsInCart[(indexPath as NSIndexPath).row - 1]
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
                let promotionInCart = section.promotionsInCart[(indexPath as NSIndexPath).row - 1 - productsCount]
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
            cell.ProductQuantitySlider.tag = (indexPath as NSIndexPath).section + 100
            cell.ProductQuantitySlider.configureSlider(minValue: 0, maxValue: 10, thumbImage: "oval", insideRetangle: "insideRetangle", outsideRetangle: "outsideRetangle")
            
            cell.tagTeste = (indexPath as NSIndexPath).section
            cell.petShopInCart = section
            
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CartViewController.tableViewTap))
            gestureRecognizer.cancelsTouchesInView = false
            cell.ProductQuantitySlider.addGestureRecognizer(gestureRecognizer)
            
            break
        }
        
        
        cell.indexPath = (indexPath as NSIndexPath).row
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableViewTap (_ tapGesture: UIPanGestureRecognizer) {
        
        let point: CGPoint = tapGesture.location(in: self.CartTableView)
        let indexPath = self.CartTableView.indexPathForRow(at: point)
        if indexPath == nil {
            print("TAPPED OUTSIDE CELL")
        } else {
            
            let cell = self.CartTableView.cellForRow(at: indexPath!)
            if let cell = cell as? CartTableViewCell {
                //                print("TAPPED CELL\(cell.price)")
                self.workingCell = cell
                
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func SliderValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
        let allTouches = event.allTouches
        
        if let finishCell = self.view.viewWithTag(sender.tag - 90) as? CartTableViewCell {
            if allTouches?.count > 0 {
                
                let phase = (allTouches?.first as UITouch!).phase
                
                // GUARDA VALORES INICIAIS
                if phase == UITouchPhase.began {
                    let a = Int(round(sender.value))
                    if a != 0 {
                        beganSliding = a
                        beganPrice = finishCell.beganPrice
                    }
                }
                
                // TERMINOU DE MEXER NO SLIDER
                if phase == UITouchPhase.ended {
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
                        self.CartDismissDelegate?.DidDismiss(option: .UpdateCart)
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
                                self.CartDismissDelegate?.DidDismiss(option: .UpdateCart)
                            })
                            
                            // APENAS DIMINUIU
                        } else {
                            
                            finishCell.itensCount = finishCell.itensCount - (beganSliding - endedSliding)
                            finishCell.FinishOrderQuantityLabel.text = "\(finishCell.itensCount)"
                            
                            if let workingCell = workingCell {
                                finishCell.price = finishCell.price - (Double(beganSliding) * workingCell.price) + (Double(endedSliding) * workingCell.price)
                                
                                
                                finishCell.FinishOrderPriceLabel.text = "\(finishCell.price)"
                                
                                let object = workingCell.petShopInCart!.petShop!.objectId
                                Cart.sharedInstance.cartDict.petShopList[object]?.updateQuantity(workingCell.productInCart, promotion: workingCell.promotionInCart, petShopId: object, newQuantity: endedSliding)
                                self.CartDismissDelegate?.DidDismiss(option: .UpdateCart)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func didFinishTransaction(_ message: String) {
        print(message)
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        switch message {
        case "Captured":
            alert.title = "Pagamento Efetuado"
            alert.message = "Sua compra foi realizada com sucesso, aguarde a entrega."
            alert.addAction(UIAlertAction(title: "Ir para Meus Pedidos", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.tabBarController?.selectedIndex = 2
            }))
            alert.addAction(UIAlertAction(title: "Voltar ao Carrinho", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        case "Voided":
            alert.title = "Falha no Pagamento"
            alert.message = "Ocorreu algum problema na hora de confirmar o pagamento. Revise seus dados"
            alert.addAction(UIAlertAction(title: "Voltar ao Carrinho", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertRemovedItem(_ shouldRemoveItem: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Carrinho", message: "Deseja remover este item do carrinho?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: .default , handler: { action in
            print("Deletou")
            shouldRemoveItem(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel , handler: { action in
            print("Cancelou")
            shouldRemoveItem(false)
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToOrderResumeWithOrder(_ petShop: PetshopInCart){
        self.performSegue(withIdentifier: "goToOrderResume", sender: petShop)
    }
    
    //MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOrderResume"{
            let vc = segue.destination as! OrderResumeViewController
            vc.petShopInCard = sender as? PetshopInCart
        }
    }
}
