//
//  OrderResumeViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 9/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class OrderResumeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CardIOPaymentViewControllerDelegate, AddAddressDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let numberOfSections = 3
    var numberOfRowSection0 = 3
    var numberOfRowSection1 = 2
    var numberOfRowSection2 = 1
    var petShopInCard: PetshopInCart?
    var addressList: [Address] = []{
        didSet{
            self.numberOfRowSection1 = self.addressList.count+2
        }
    }
    var addressSelected: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        CardIOUtilities.preload()
        
        let products = self.petShopInCard!.productsInCart
        let promotions = self.petShopInCard!.promotionsInCart
        self.numberOfRowSection0 += products.count+promotions.count
        
        if let user = UserManager.sharedInstance.user {
            self.addressList = user.addressList
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.numberOfRowSection0
        case 1:
            return self.numberOfRowSection1
        default:
            return self.numberOfRowSection2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0{
            switch (indexPath as NSIndexPath).row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CustomTableViewCell
                cell.firstLbl.text = "Resumo do seu pedido"
                return cell
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "petShopCell") as! PetShopsTableViewCell
                cell.petShop = self.petShopInCard?.petShop
                return cell
                
            case self.numberOfRowSection0-1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
                cell.firstLbl.text = String(self.petShopInCard!.totalQuantity)
                cell.secondLbl.text = NSNumber(value: self.petShopInCard!.totalPrice as Double).numberToPrice()
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
                var index = (indexPath as NSIndexPath).row-2
                let products = self.petShopInCard!.productsInCart
                let promotions = self.petShopInCard!.promotionsInCart
                
                if index<products.count{
                    cell.product = products[index].product
                    cell.lblQuant.text = cell.lblQuant.text!+String(products[index].quantity)
                    cell.lblTotal.text = cell.lblTotal.text!+NSNumber(value: (products[index].product.price.doubleValue * Double(products[index].quantity)) as Double).numberToPrice()
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
        else if (indexPath as NSIndexPath).section == 1{
            switch (indexPath as NSIndexPath).row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CustomTableViewCell
                cell.firstLbl.text = "Escolha o endereço de entrega"
                return cell
                
            case self.numberOfRowSection1-1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                let address = self.addressList[(indexPath as NSIndexPath).row-1]
                cell.firstLbl.text = address.name.isEmpty ? address.street : "\(address.name)"
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "finisheCell") as! CustomTableViewCell
            cell.finisheBt.addTarget(self, action: #selector(OrderResumeViewController.didPressFinisheBt), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row < self.numberOfRowSection1-1 && indexPath.row > 0 {
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            cell.selectAddress()
            self.addressSelected = self.addressList[indexPath.row-1]
        }
        else if indexPath.section == 1 && indexPath.row == self.numberOfRowSection1-1{
            self.addressSelected = nil
            performSegue(withIdentifier: "goToAddAddress", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row < self.numberOfRowSection1 && indexPath.row > 0{
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row < self.numberOfRowSection1-1 && indexPath.row > 0 {
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            cell.deselectAddress()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                return 45
                
            case 1:
                return 90
                
            default:
                return 60
            }
        }
        else if indexPath.section == 1{
            return 45
        }
        else{
            return 65
        }
    }
    
    // MARK: CardIO delegate
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
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddAddress"{
            let addAddressVC = segue.destination as! AddressViewController
            addAddressVC.delegate = self
        }
    }
    
    // MARK: Finishe functions
    func showAlert(){
        let alert = UIAlertController(title: "Atenção", message: "Por favor selecione o local de entrega", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didPressFinisheBt(){
        if self.addressSelected != nil{
            self.scanCard("" as AnyObject)
        }
        else{
            self.showAlert()
        }
    }
    
    // MARK: Address delegate
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
                    data["addressId"] = self.addressSelected!.addressId as AnyObject?
                    
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
    
    func addressAdded(_ address: Address){
        UserManager.sharedInstance.user?.addressList.append(address)
        self.addressList = (UserManager.sharedInstance.user?.addressList)!
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
}
