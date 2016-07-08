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
    @IBOutlet weak var petShopDistrict: UILabel!
    @IBOutlet weak var petShopDistance: UILabel!
    
    // MARK: Variables
    var petShop: PetShop?{
        didSet{
            if let petshop = self.petShop{
                self.petShopName.text = petshop.name
                self.petShopAdress.text = petshop.address
                self.petShopImage.image = petshop.imageFile
                self.petShopDistance.text = "calcular"
                self.petShopDistrict.text = "faltou"
                //self.products = petshop.products
            }
        }
    }
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
    
    func reloadProducts() {
        ProductManager().getProductList("petShopId") { (products) in
            self.products = products
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.refreshControl = UIRefreshControl()
        self.tableView.tableFooterView = UIView()
        
        var product = Product(data: ["name":"Osso Grande" , "description":"osso de catioro azul ou branco com cheirinho de delicia e ppk tbm, escolha o cheirinho que vc quer muito bem para o bem da sua mulher" , "price":12.50 , "stock":10 , "brand":"pedigrilson"])
        var vetor = [product]
        
        product = Product(data: ["name":"Osso Pequeno" , "description":"osso de catioro" , "price":12.50 , "stock":10 , "brand":"pedigrilson"])
        vetor.append(product)
        
        product = Product(data: ["name":"bolinha" , "description":"osso de catioro" , "price":12.50 , "stock":10 , "brand":"pedigrilson"])
        vetor.append(product)

        product = Product(data: ["name":"racao Grande" , "description":"osso de catioro" , "price":12.50 , "stock":10 , "brand":"pedigrilson"])
        vetor.append(product)

        product = Product(data: ["name":"racao pequena" , "description":"osso de catioro" , "price":12.50 , "stock":10 , "brand":"pedigrilson"])
        vetor.append(product)
        
        self.products = vetor
    }
    
    // MARK: Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCellWithIdentifier("cellHeader") as! ProductHeaderTableViewCell
    }

    // MARK: Table view delegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: Functions
    func filterProductsForSearchText(searchText: String, scope: String = "All") {
        self.filteredProducts = products!.filter { product in
            return product.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        self.tableView.reloadData()
    }

}

extension ProductTableViewController: UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterProductsForSearchText(searchController.searchBar.text!)
    }
}
