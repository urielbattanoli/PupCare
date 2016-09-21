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
    
    var order: Order?
    var numberOfRowInsection = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        if self.order?.products.count==0{
            OrderManager.sharedInstance.getOrderProducts(self.order!, block: { (products) in
                self.order!.products = products
                self.numberOfRowInsection += products.count ?? 0
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
        }
        else{
            self.numberOfRowInsection += self.order?.products.count ?? 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Tableview data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowInsection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).row {
        case 0:
            //pet shop infos
            let cell = tableView.dequeueReusableCell(withIdentifier: "petShopCell") as! PetShopsTableViewCell
            cell.petShop = self.order?.petShop
            return cell
            
        case self.numberOfRowInsection-3:
            //quant
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell") as! CustomTableViewCell
            cell.firstLbl.text = "Quantidade total de produtos:"
            cell.secondLbl.text = "\(self.order!.totalQuantity)"
            return cell
            
        case self.numberOfRowInsection-2:
            //delivery
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell") as! CustomTableViewCell
            cell.firstLbl.text = "Frete:"
            cell.secondLbl.text = self.order?.shipment.numberToPrice()
            return cell
            
        case self.numberOfRowInsection-1:
            //price
            let cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell") as! CustomTableViewCell
            cell.firstLbl.text = "Valor total do pedido:"
            cell.secondLbl.text = self.order?.price.numberToPrice()
            return cell
            
        default:
            //product list
            let product = self.order?.products[(indexPath as NSIndexPath).row-1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as! ProductTableViewCell
            cell.product = product
            cell.lblQuant.text = "\(product!.stock) itens comprados"
            
            return cell
        }
    }
    
    // MARK: Tableview delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0{
            return 90
        }
        if (indexPath as NSIndexPath).row > self.numberOfRowInsection-4{
            return 40
        }
        return 105
    }
}
