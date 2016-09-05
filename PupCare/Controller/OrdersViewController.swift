//
//  OrdersViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/20/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var orders: [Order] = []{
        didSet{
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PetShopManager.sharedInstance.getNearPetShops(10, longitude: 10, withinKilometers: 10) { (petshops, error) in
            let data = ["orderId":"asd123asd24a",
                        "petShop": petshops![0],
                        "date": NSDate(),
                        "price": 145.00,
                        "trackId": "3293jsdijsbd"]
            let order = Order(data: data)
            self.orders = [order, order, order]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderCell") as! OrderTableViewCell
        
        cell.order = self.orders[indexPath.row]
        cell.petShopDetailBT.addTarget(self, action: #selector(OrdersViewController.didPressDetailBT), forControlEvents: .TouchUpInside)
        cell.petShopDetailBT.tag = indexPath.row
        
        return cell
    }
    
    //MARK: TableView delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! OrderHeaderTableViewCell
        
        cell.titleLabel.text = "Histórico de pedidos"
        
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    // MARK: Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToOrderDetail"{
            let orderDetailVC = segue.destinationViewController as! OrderDetailViewController
            orderDetailVC.order = sender as? Order
        }
    }
    
    func didPressDetailBT(sender: AnyObject) {
        if let detailBT = sender as? UIButton{
            self.performSegueWithIdentifier("goToOrderDetail", sender: self.orders[detailBT.tag])
        }
    }
}
