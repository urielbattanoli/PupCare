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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        CardIOUtilities.preload()
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
            //cell.petShop = ????
            return cell
        case self.numberOfRowSection1-2:
            let cell = tableView.dequeueReusableCellWithIdentifier("customCell") as! CustomTableViewCell
            //cell.firstLbl.text = quantidades total de itens
            //cell.secondLbl.text = valor total do pedido
            return cell
        case self.numberOfRowSection1-1:
            let cell = tableView.dequeueReusableCellWithIdentifier("finisheCell") as! CustomTableViewCell
            cell.finisheBt.addTarget(self, action: #selector(OrderResumeViewController.didPressFinisheBt), forControlEvents: .TouchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell") as! ProductTableViewCell
            //cell.product = product
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
        
    }
}
