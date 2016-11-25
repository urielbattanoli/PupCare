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
    @IBOutlet weak var backgroundViewWhenWithoutOrders: UIView!
    
    //MARK: Variables
    var orders: [Order] = []{
        didSet{
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(OrdersViewController.reloadOrderTableView), name: .whenDidFinishOrder, object: nil)
        self.loadUsersOrder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadUsersOrder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUsersOrder(){
        if UserManager.sharedInstance.user != nil{
            OrderManager.sharedInstance.getOrderList { (orders) in
                self.orders = orders
                self.backgroundViewWhenWithoutOrders.isHidden = orders.count != 0
            }
        }
    }
    
    @IBAction func didPressGoToPetShops(_ sender: Any) {
        if let tabbar = self.tabBarController {
            tabbar.selectedIndex = 1
        }
    }
    
    func reloadOrderTableView(){
        self.loadUsersOrder()
    }
    
    //MARK: TableView data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as! OrderTableViewCell
        
        cell.order = self.orders[(indexPath as NSIndexPath).row]
        cell.petShopDetailBT.addTarget(self, action: #selector(OrdersViewController.didPressDetailBT), for: .touchUpInside)
        cell.petShopDetailBT.tag = (indexPath as NSIndexPath).row
        
        return cell
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! OrderHeaderTableViewCell
        
        cell.titleLabel.text = "Histórico de pedidos"
        
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // MARK: Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOrderDetail"{
            let orderDetailVC = segue.destination as! OrderDetailViewController
            orderDetailVC.order = sender as? Order
        }
    }
    
    func didPressDetailBT(_ sender: AnyObject) {
        if let detailBT = sender as? UIButton{
            self.performSegue(withIdentifier: "goToOrderDetail", sender: self.orders[detailBT.tag])
        }
    }
}
