//
//  OrderDetailViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/31/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var order: Order?{
        didSet{
            if let order = self.order{
                OrderManager.sharedInstance.getOrderProducts(order, block: { (products) in
                    order.products = products
                })
            }
        }
    }
    var numberOfRowInsection = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.numberOfRowInsection += self.order?.products.count ?? 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowInsection
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            //pet shop infos
            let cell = tableView.dequeueReusableCellWithIdentifier("petShopCell") as! PetShopsTableViewCell
            cell.petShop = self.order?.petShop
            return cell
            
        case self.numberOfRowInsection-3:
            //quant
            let cell = tableView.dequeueReusableCellWithIdentifier("bottomCell") as! CustomTableViewCell
            cell.leftLbl.text = "Quantidade total de produtos:"
            cell.rigthLbl.text = "\(self.order!.totalQuantity)"
            return cell
            
        case self.numberOfRowInsection-2:
            //delivery
            let cell = tableView.dequeueReusableCellWithIdentifier("bottomCell") as! CustomTableViewCell
            cell.leftLbl.text = "Frete:"
            cell.rigthLbl.text = self.order?.shipment.numberToPrice()
            return cell
            
        case self.numberOfRowInsection-1:
            //price
            let cell = tableView.dequeueReusableCellWithIdentifier("bottomCell") as! CustomTableViewCell
            cell.leftLbl.text = "Valor total do pedido:"
            cell.rigthLbl.text = self.order?.price.numberToPrice()
            return cell
            
        default:
            //product list
            let product = self.order?.products[indexPath.row-1]
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell") as! ProductTableViewCell
            cell.product = product
            
            return cell
        }
    }
    
    // MARK: Tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 90
        }
        if indexPath.row > self.numberOfRowInsection-4{
            return 40
        }
        return 105
    }
}
