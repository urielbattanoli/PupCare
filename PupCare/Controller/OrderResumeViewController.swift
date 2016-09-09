//
//  OrderResumeViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 9/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class OrderResumeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CardIOPaymentViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var numberOfRowSection1 = 4
    var petShopInCard: PetshopInCart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        CardIOUtilities.preload()
    
        let products = self.petShopInCard!.productsInCart
        let promotions = self.petShopInCard!.promotionsInCart
        self.numberOfRowSection1 += products.count+promotions.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowSection1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! CustomTableViewCell
            cell.firstLbl.text = "Resumo do seu pedido"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("petShopCell") as! PetShopsTableViewCell
            cell.petShop = self.petShopInCard?.petShop
            return cell
            
        case self.numberOfRowSection1-2:
            let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomTableViewCell
            cell.firstLbl.text = String(self.petShopInCard!.totalQuantity)
            cell.secondLbl.text = NSNumber(double: self.petShopInCard!.totalPrice).numberToPrice()
            return cell
            
        case self.numberOfRowSection1-1:
            let cell = tableView.dequeueReusableCellWithIdentifier("finisheCell") as! CustomTableViewCell
            cell.finisheBt.addTarget(self, action: #selector(OrderResumeViewController.didPressFinisheBt), forControlEvents: .TouchUpInside)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell") as! ProductTableViewCell
            //cell.product = product
            var index = indexPath.row-2
            let products = self.petShopInCard!.productsInCart
            let promotions = self.petShopInCard!.promotionsInCart
            
            if index<products.count{
                cell.product = products[index].product
                cell.lblQuant.text = cell.lblQuant.text!+String(products[index].quantity)
            }
            else{
                index -= products.count
                cell.promotion = promotions[index].promotion
                cell.lblQuant.text = cell.lblQuant.text!+String(promotions[index].quantity)
                
                let total = Float(promotions[index].quantity)*promotions[index].promotion.newPrice
                cell.lblTotal.text = cell.lblTotal.text!+NSNumber(float: total).numberToPrice()
            }
            return cell
        }
    }
    
    //MARK: Tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 45
            
        case 1:
            return 90
            
        case self.numberOfRowSection1-2:
            return 60
            
        case self.numberOfRowSection1-1:
            return 65
            
        default:
            return 60
        }
    }
    
    //MARK: CardIO delegate
    func scanCard(sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        presentViewController(cardIOVC, animated: true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            var data = [String : AnyObject]()
            data["CardHolderName"] = info.cardholderName
            data["CardNumber"] = info.cardNumber
            data["CVV"] = info.cvv
            data["ExpirationYear"] = info.expiryYear
            data["ExpirationMonth"] = info.expiryMonth
            
            self.validateCardAndCreateOrder(data)
        }
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Finishe functions
    func didPressFinisheBt(){
        self.scanCard("")
    }
    
    func validateCardAndCreateOrder(cardInfo: [String : AnyObject]){
        var cardInfo = cardInfo
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            OrderManager.sharedInstance.checkIfCardIsValid(cardInfo["CardNumber"] as! String) { (cardBrand) in
                cardInfo["CardBrand"] = cardBrand
                
                OrderManager.sharedInstance.startTransaction(cardInfo["price"] as! Double, cardInfo: cardInfo, callback: { (message, trackId) in
                    
                    let petShop = cardInfo["petShop"] as! PetShop
                    
                    var data = [String:AnyObject]()
                    data["orderId"] = ""
                    data["date"] = NSDate()
                    data["trackId"] = trackId
                    data["price"] = cardInfo["price"]
                    data["shipment"] = 10
                    data["petShop"] = petShop.objectId
                    
                    OrderManager.sharedInstance.saveOrder(data, callback: { (orderId) in
                        
                        for product in (Cart.sharedInstance.cartDict.petShopList[petShop.objectId]?.productsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["productId"] = product.product.objectId
                            data["quantity"] = product.quantity
                            data["price"] = product.product.price
                            
                            OrderManager.sharedInstance.saveProductsFromOrder(data)
                        }
                        
                        for promotion in (Cart.sharedInstance.cartDict.petShopList[petShop.objectId]?.promotionsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["promotionId"] = promotion.promotion.objectId
                            data["price"] = promotion.promotion.newPrice
                            
                            OrderManager.sharedInstance.savePromotionsFromOrder(data)
                        }
                    })
                    
                    self.didFinishTransaction(message)
                })
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
}
