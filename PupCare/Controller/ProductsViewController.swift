//
//  ProductsViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 6/30/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var productsTableView: UITableView!
    
    //MARK: Variables
    
    //MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.productsTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let productCell = tableView.dequeueReusableCellWithIdentifier("productCell") as! ProductTableViewCell
        
        return productCell
    }
    
    //MARK: TableView Delegate
}
