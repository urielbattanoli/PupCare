//
//  ProductTableViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/5/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class ProductTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    
    // MARK: outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var petShopImage: UIImageView!
    @IBOutlet weak var petShopName: UILabel!
    @IBOutlet weak var petShopAdress: UILabel!
    @IBOutlet weak var petShopNeighbourhood: UILabel!
    @IBOutlet weak var petShopDistance: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Variables
    var petShop: PetShop?
    
    var products: [Product]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var filteredProducts: [Product] = []
    
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
        
        self.title = "Detalhes da Pet Shop"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Voltar", style: .Plain, target: nil, action: nil)
        
        self.searchBar.delegate = self
        if let searchField = self.searchBar.valueForKey("searchField") as? UITextField{
            searchField.backgroundColor = self.searchBar.backgroundColor
            searchField.textColor = UIColor.whiteColor()
            self.searchBar.barTintColor = UIColor.whiteColor()
            self.searchBar.backgroundColor = UIColor.whiteColor()
            
            if let placeholder = searchField.valueForKey("placeholderLabel") as? UILabel{
                placeholder.textColor = UIColor.whiteColor()
            }
        }
        
        
        self.refreshControl = UIRefreshControl()
        self.tableView.tableFooterView = UIView()
        
        if let petShop = self.petShop{
            self.petShopName.text = petShop.name
            self.petShopAdress.text = petShop.address
            self.petShopImage.loadImage(petShop.imageUrl)
            self.petShopNeighbourhood.text = petShop.neighbourhood
            
            if let location = UserManager.sharedInstance.getLocationToSearch(){
                self.petShopDistance.text = "\((petShop.location.distanceFromLocation(location)/1000).roundToPlaces(2)) km"
            }
            
            if petShop.products.count > 0{
                self.products = petShop.products
            }
            else{
                ProductManager.getProductList(petShop.objectId, block: { (products) in
                    petShop.products = products
                    self.products = products
                })
            }
        }
    }
    
    // MARK: Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  !(self.searchBar.text?.isEmpty)! {
            return self.filteredProducts.count ?? 0
        }
        else{
            return self.products?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellProduct", forIndexPath: indexPath) as! ProductTableViewCell
        
        if !(self.searchBar.text?.isEmpty)! {
            cell.product = self.filteredProducts[indexPath.row]
        } else {
            cell.product = self.products![indexPath.row]
        }
        
        return cell
    }
    
    // MARK: Table view delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("goToDetail", sender: self.products![indexPath.row])
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: SearchBar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterProductsForSearchText(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        self.filterProductsForSearchText("")
        self.view.endEditing(true)
    }
    
    // MARK: Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetail"{
            let productDetail = segue.destinationViewController as! ProductDetailViewController
            
            productDetail.product = sender as? Product
            productDetail.petshop = self.petShop
        }
    }
    
    func filterProductsForSearchText(searchText: String, scope: String = "All") {
        self.filteredProducts = products!.filter { product in
            return product.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.tableView.reloadData()
        
        if searchText.isEmpty{
            searchBar.showsCancelButton = false
        }else{
            searchBar.showsCancelButton = true
        }
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
