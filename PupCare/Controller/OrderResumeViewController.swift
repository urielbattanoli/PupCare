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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("petShopCell")
        return cell!
    }
    
    //MARK: Tableview delegate
    
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
