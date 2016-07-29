//
//  MyProfileCardTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/26/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class MyProfileCardTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var imageCard: UIImageView!
    
    var card: Card?{
        didSet{
            if let card = self.card{
                self.lblCard.text = "\(card.number)"
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
        
        self.viewBack.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.viewBack.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
