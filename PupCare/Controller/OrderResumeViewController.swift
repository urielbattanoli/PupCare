//
//  OrderResumeViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 9/8/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class OrderResumeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddAddressDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let numberOfSections = 4
    var numberOfRowSection0 = 3
    var numberOfRowSection1 = 3
    var numberOfRowSection2 = 3
    var numberOfRowSection3 = 1
    var petShopInCard: PetshopInCart?
    var addressList: [Address] = []{
        didSet{
            self.numberOfRowSection1 = self.addressList.count+2
        }
    }
    var addressSelected: Address?
    var paymentMethod: Int?
    var indexPathOfSection1Selected: IndexPath?
    var indexPathOfSection2Selected: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        //        CardIOUtilities.preload()
        
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
        case 2 :
            return self.numberOfRowSection2
        default:
            return self.numberOfRowSection3
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
                    cell.lblQuant.text = "Quantidade: "+String(products[index].quantity)
                    cell.lblTotal.text = "Total: "+NSNumber(value: (products[index].product.price.doubleValue * Double(products[index].quantity)) as Double).numberToPrice()
                }
                else{
                    index -= products.count
                    cell.promotion = promotions[index].promotion
                    cell.lblQuant.text = "Quantidade: "+String(promotions[index].quantity)
                    
                    let total = Float(promotions[index].quantity)*promotions[index].promotion.newPrice
                    cell.lblTotal.text = "Total: "+NSNumber(value: total as Float).numberToPrice()
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
                
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                cell.firstLbl.text = "Retira na pet shop"
                cell.markSelected.isHidden = false
                return cell
                
            case self.numberOfRowSection1-1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                cell.markSelected.isHidden = true
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                let address = self.addressList[(indexPath as NSIndexPath).row-1]
                cell.firstLbl.text = address.name.isEmpty ? address.street : "\(address.name)"
                cell.markSelected.isHidden = false
                return cell
            }
        }
        else if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CustomTableViewCell
                cell.firstLbl.text = "Escolha a forma de pagamento"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                cell.firstLbl.text = "Dinheiro"
                cell.markSelected.isHidden = false
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell") as! CustomTableViewCell
                cell.firstLbl.text = "Cartão"
                cell.markSelected.isHidden = false
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "finisheCell") as! CustomTableViewCell
            cell.finisheBt.addTarget(self, action: #selector(OrderResumeViewController.didPressFinishBt), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row < self.numberOfRowSection1-1 && indexPath.row > 0 {
                
                let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                cell.selectAddress()
                if indexPath.row == 1{
                    self.addressSelected = self.petShopInCard!.petShop!.address
                }
                else{
                    self.addressSelected = self.addressList[indexPath.row-1]
                }
            }
            else if  indexPath.row == self.numberOfRowSection1-1{
                self.addressSelected = nil
                self.indexPathOfSection1Selected = nil
                performSegue(withIdentifier: "goToAddAddress", sender: nil)
            }
        }
        else if indexPath.section == 2{
            if indexPath.row < self.numberOfRowSection2 && indexPath.row > 0 {
                
                let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                cell.selectAddress()
                self.paymentMethod = indexPath.row
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.section == 1 && indexPath.row < self.numberOfRowSection1 && indexPath.row > 0) || (indexPath.section == 2 && indexPath.row < self.numberOfRowSection2 && indexPath.row > 0){
            if indexPath.section == 1 {
                if self.indexPathOfSection1Selected != nil{
                    self.deselectRowAt(tableView: tableView, indexPath: self.indexPathOfSection1Selected!)
                }
                self.indexPathOfSection1Selected = indexPath
            }
            else {
                if self.indexPathOfSection2Selected != nil{
                    self.deselectRowAt(tableView: tableView, indexPath: self.indexPathOfSection2Selected!)
                }
                self.indexPathOfSection2Selected = indexPath
            }
            return indexPath
        }
        return nil
    }
    
    func deselectRowAt(tableView: UITableView, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        cell.deselectAddress()
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
        else if indexPath.section == 1 || indexPath.section == 2{
            return 45
        }
        else{
            return 65
        }
    }
    
    // MARK: CardIO delegate
    //    func scanCard(_ sender: AnyObject) {
    //        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
    //        cardIOVC?.modalPresentationStyle = .formSheet
    //        present(cardIOVC!, animated: true, completion: nil)
    //    }
    //
    //    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
    //        paymentViewController?.dismiss(animated: true, completion: nil)
    //    }
    //
    //    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
    //        if let info = cardInfo {
    //            var data = [String : AnyObject]()
    //            data["CardHolderName"] = info.cardholderName as AnyObject?
    //            data["CardNumber"] = info.cardNumber as AnyObject?
    //            data["CVV"] = info.cvv as AnyObject?
    //            data["ExpirationYear"] = info.expiryYear as AnyObject?
    //            data["ExpirationMonth"] = info.expiryMonth as AnyObject?
    //
    //            self.validateCardAndCreateOrder(data)
    //        }
    //        paymentViewController?.dismiss(animated: true, completion: nil)
    //    }
    
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddAddress"{
            let addAddressVC = segue.destination as! AddressViewController
            addAddressVC.delegate = self
        }
    }
    
    // MARK: Finish functions
    func showAlertWhenAddressOrPayMetIsNil() -> Bool{
        let alert = UIAlertController(title: "Atenção", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        if self.addressSelected == nil{
            alert.message = "Por favor selecione o local de entrega"
            self.present(alert, animated: true, completion: nil)
            return true
        }
        if self.paymentMethod == nil{
            alert.message = "Por favor selecione o método de pagamento"
            self.present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func didPressFinishBt(){
        if self.showAlertWhenAddressOrPayMetIsNil() {
            return
        }
        //        self.scanCard("" as AnyObject)
        self.createOrderGenerateTrackId()
    }
    
    func createOrderGenerateTrackId() {
        OrderManager.sharedInstance.generateTrackId { (trackId) in
            self.createOrder(trackId)
        }
    }
    
    func createOrder(_ trackId: AnyObject){
        let petShop = self.petShopInCard?.petShop!
        var order = [String:AnyObject]()
        order["orderId"] = "" as AnyObject?
        order["date"] = Date() as AnyObject?
        order["trackId"] = trackId
        order["price"] = self.petShopInCard!.totalPrice as AnyObject?
        order["shipment"] = 10 as AnyObject?
        order["petShop"] =  petShop?.objectId as AnyObject?
        order["addressId"] = self.addressSelected!.addressId as AnyObject?
        
        OrderManager.sharedInstance.saveOrder(order, callback: { (orderId) in
            
            for product in (Cart.sharedInstance.cartDict.petShopList[(petShop?.objectId)!]?.productsInCart)! {
                var data = [String:AnyObject]()
                
                data["orderId"] = orderId
                data["productId"] = product.product.objectId as AnyObject?
                data["quantity"] = product.quantity as AnyObject?
                data["price"] = product.product.price
                
                OrderManager.sharedInstance.saveProductsFromOrder(data)
            }
            
            for promotion in (Cart.sharedInstance.cartDict.petShopList[(petShop?.objectId)!]?.promotionsInCart)! {
                var data = [String:AnyObject]()
                
                data["orderId"] = orderId
                data["promotionId"] = promotion.promotion.objectId as AnyObject?
                data["price"] = promotion.promotion.newPrice as AnyObject?
                
                OrderManager.sharedInstance.savePromotionsFromOrder(data)
            }
        })
        
        let receiveAtHome = petShop?.address == self.addressSelected!
        self.showAlertWhenOrderFinished(receiveAtHome)
    }
    
    func showAlertWhenOrderFinished(_ receiveAtHome: Bool) {
        let alert = UIAlertController(title: "Pedido realizado com sucesso", message: "", preferredStyle: .alert)
        if receiveAtHome{
            alert.message = "Seu pedido está sendo separado, dentro de 30 minutos estará pronto."
        }
        else{
            alert.message = "Seu pedido está sendo separado, aguarde a entrega."
        }
        
        alert.addAction(UIAlertAction(title: "Ir para Meus Pedidos", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 2
        }))
        alert.addAction(UIAlertAction(title: "Voltar ao Carrinho", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Address delegate
    func validateCardAndCreateOrder(_ cardInfo: [String : AnyObject]){
        var cardInfo = cardInfo
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            OrderManager.sharedInstance.checkIfCardIsValid(cardInfo["CardNumber"] as! String) { (cardBrand) in
                cardInfo["CardBrand"] = cardBrand as AnyObject?
                
                OrderManager.sharedInstance.startTransaction(cardInfo["price"] as! Double, cardInfo: cardInfo, callback: { (message, trackId) in
                    
                    self.createOrder(trackId)
                    
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
