//
//  MyProfileAddressTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 8/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class MyProfileAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imageAddress: UIImageView!
    
    var address: Address?{
        didSet{
            if let address = self.address{
                self.lblAddress.text = "\(address.name)"
            }
        }
    }
    
    func setCorner() {
        if let view = self.viewBack{
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBack.layer.borderColor = UIColor(red: 205, green: 205, blue: 205).CGColor
        self.viewBack.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
