//
//  ProductTableViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var petShopImage: UIImageView!
    @IBOutlet weak var petShopName: UILabel!
    @IBOutlet weak var petShopAdress: UILabel!
    @IBOutlet weak var petShopNeighbourhood: UILabel!
    @IBOutlet weak var petShopDistance: UILabel!
    
    // MARK: Variables
    var petShop: PetShop?
    
    var products: [Product]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var filteredProducts: [Product] = []
    
    var searchController: UISearchController?{
        didSet{
            self.searchController?.hidesNavigationBarDuringPresentation = false
            self.searchController?.searchResultsUpdater = self
            self.searchController?.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            self.tableView.tableHeaderView = searchController!.searchBar
        }
    }
    
    var refreshControl: UIRefreshControl?{
        didSet{
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Puxe para Atualizar")
            self.refreshControl?.addTarget(self, action: #selector(ProductTableViewController.reloadProducts), forControlEvents: .ValueChanged)
            self.tableView.addSubview(self.refreshControl!)
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.refreshControl = UIRefreshControl()
        self.tableView.tableFooterView = UIView()
        
        if let petshop = self.petShop{
            self.petShopName.text = petshop.name
            self.petShopAdress.text = petshop.address
            self.petShopImage.loadImage(petShop!.imageUrl)
            self.petShopDistance.text = "calcular"
            self.petShopNeighbourhood.text = petshop.neighbourhood
            if petshop.products.count > 0{
                self.products = petshop.products
            }
            else{
                ProductManager.getProductList((petShop?.objectId)!, block: { (products) in
                    petshop.products = products
                    self.products = products
                })
            }
        }
    }
    
    // MARK: Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCellWithIdentifier("cellHeader") as! ProductHeaderTableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController!.active && searchController!.searchBar.text != "" {
            return self.filteredProducts.count ?? 0
        }
        else{
            return self.products?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellProduct", forIndexPath: indexPath) as! ProductTableViewCell
        
        if searchController!.active && searchController!.searchBar.text != "" {
            cell.product = self.filteredProducts[indexPath.row]
        } else {
            cell.product = self.products![indexPath.row]
        }
        
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("goToDetail", sender: self.products![indexPath.row])
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetail"{
            let productDetail = segue.destinationViewController as! ProductDetailViewController
            
            productDetail.product = sender as? Product
        }
    }
    
    func filterProductsForSearchText(searchText: String, scope: String = "All") {
        self.filteredProducts = products!.filter { product in
            return product.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.tableView.reloadData()
    }
    
    
    func reloadProducts() {
        ProductManager.getProductList((petShop?.objectId)!) { (products) in
            self.products = products
            self.refreshControl?.endRefreshing()
        }
    }
}

extension ProductTableViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterProductsForSearchText(searchController.searchBar.text!)
    }
}
