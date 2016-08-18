//
//  OrderTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/12/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var petShopImage: IMGAttributedStyle!
    @IBOutlet weak var petshopNameLbl: UILabel!
    @IBOutlet weak var orderCodLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    
    //MARK: Variables
    var order: Order?{
        didSet{
            if let order = self.order{
                self.petShopImage.loadImage(order.petShop.imageUrl)
                self.petshopNameLbl.text = order.petShop.name
                self.orderCodLbl.text = "Código: \(order.orderId)"
                self.orderDateLbl.text = "Data: \(order.orderDate.dateToString())"
                self.orderPriceLbl.text = "Valor: \(order.price.numberToPrice())"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBackground.layer.cornerRadius = 5
        self.viewBackground.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).CGColor
        self.viewBackground.layer.borderWidth = 0.5
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
