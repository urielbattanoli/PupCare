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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowSection1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CustomTableViewCell
            cell.firstLbl.text = "Resumo do seu pedido"
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "petShopCell") as! PetShopsTableViewCell
            cell.petShop = self.petShopInCard?.petShop
            return cell
            
        case self.numberOfRowSection1-2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
            cell.firstLbl.text = String(self.petShopInCard!.totalQuantity)
            cell.secondLbl.text = NSNumber(value: self.petShopInCard!.totalPrice as Double).numberToPrice()
            return cell
            
        case self.numberOfRowSection1-1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "finisheCell") as! CustomTableViewCell
            cell.finisheBt.addTarget(self, action: #selector(OrderResumeViewController.didPressFinisheBt), for: .touchUpInside)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
            //cell.product = product
            var index = (indexPath as NSIndexPath).row-2
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
                cell.lblTotal.text = cell.lblTotal.text!+NSNumber(value: total as Float).numberToPrice()
            }
            return cell
        }
    }
    
    //MARK: Tableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).row {
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
    func scanCard(_ sender: AnyObject) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            var data = [String : AnyObject]()
            data["CardHolderName"] = info.cardholderName as AnyObject?
            data["CardNumber"] = info.cardNumber as AnyObject?
            data["CVV"] = info.cvv as AnyObject?
            data["ExpirationYear"] = info.expiryYear as AnyObject?
            data["ExpirationMonth"] = info.expiryMonth as AnyObject?
            
            self.validateCardAndCreateOrder(data)
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Finishe functions
    func didPressFinisheBt(){
        //        self.scanCard("" as AnyObject)
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.title = "Desativado"
        alert.message = "Obrigado por testar o aplicativo!"
        alert.addAction(UIAlertAction(title: "Ir para Meus Pedidos", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 2
        }))
        alert.addAction(UIAlertAction(title: "Voltar ao Carrinho", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func validateCardAndCreateOrder(_ cardInfo: [String : AnyObject]){
        var cardInfo = cardInfo
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            OrderManager.sharedInstance.checkIfCardIsValid(cardInfo["CardNumber"] as! String) { (cardBrand) in
                cardInfo["CardBrand"] = cardBrand as AnyObject?
                
                OrderManager.sharedInstance.startTransaction(cardInfo["price"] as! Double, cardInfo: cardInfo, callback: { (message, trackId) in
                    
                    let petShop = cardInfo["petShop"] as! PetShop
                    
                    var data = [String:AnyObject]()
                    data["orderId"] = "" as AnyObject?
                    data["date"] = Date() as AnyObject?
                    data["trackId"] = trackId
                    data["price"] = cardInfo["price"]
                    data["shipment"] = 10 as AnyObject?
                    data["petShop"] = petShop.objectId as AnyObject?
                    
                    OrderManager.sharedInstance.saveOrder(data, callback: { (orderId) in
                        
                        for product in (Cart.sharedInstance.cartDict.petShopList[petShop.objectId]?.productsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["productId"] = product.product.objectId as AnyObject?
                            data["quantity"] = product.quantity as AnyObject?
                            data["price"] = product.product.price
                            
                            OrderManager.sharedInstance.saveProductsFromOrder(data)
                        }
                        
                        for promotion in (Cart.sharedInstance.cartDict.petShopList[petShop.objectId]?.promotionsInCart)! {
                            var data = [String:AnyObject]()
                            
                            data["orderId"] = orderId
                            data["promotionId"] = promotion.promotion.objectId as AnyObject?
                            data["price"] = promotion.promotion.newPrice as AnyObject?
                            
                            OrderManager.sharedInstance.savePromotionsFromOrder(data)
                        }
                    })
                    
                    self.didFinishTransaction(message)
                })
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
}
