//
//  MyProfileDetailTableViewCell.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/13/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit

class MyProfileDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    var string: String?{
        didSet{
            if let string = self.string{
                self.textField.text = string
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
