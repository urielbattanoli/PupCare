//
//  CartTableViewCell.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/28/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var FinishOrderButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        FinishOrderButton.backgroundColor = Config.MainColors.BlueColor
        FinishOrderButton.layer.cornerRadius = 10
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func finishOrder(sender: AnyObject) {
        
    }
}
