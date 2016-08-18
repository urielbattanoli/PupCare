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
    var processingOrders: [Order] = []{
        didSet{
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
    }
    var oldOrders: [Order] = []{
        didSet{
            self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        PetShopManager.getNearPetShops(10, longitude: 10, withinKilometers: 10) { (petshops, error) in
            let data = ["orderId":"asd123asd24a",
                        "petShop": petshops![0],
                        "date": NSDate(),
                        "price": 145.00]
            let order = Order(data: data)
            self.oldOrders = [order, order]
            self.processingOrders = [order, order, order]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: TableView data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.processingOrders.count
        case 1:
            return self.oldOrders.count
        default:
            print("numbersOfRows default")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderCell") as! OrderTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.order = self.processingOrders[indexPath.row]
        case 1:
            cell.order = self.oldOrders[indexPath.row]
        default:
            print("cellForRow default")
        }
        
        return cell
    }
    
    //MARK: TableView delegate
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! OrderHeaderTableViewCell
        switch section {
        case 0:
            cell.titleLabel.text = "Em andamento"
        case 1:
            cell.titleLabel.text = "Histórico de pedidos"
        default:
            print("viewForHeader default")
        }
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
}
