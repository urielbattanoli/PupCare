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
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var string: String?{
        didSet{
            if let string = self.string{
                if string == "Sair" {
                    self.viewBack.layer.borderColor = UIColor.clearColor().CGColor
                }
                self.textField.text = string
            }
        }
    }
    
    func changeConstraintSize(size: CGFloat) {
        if let constraint = self.bottomConstraint{
            constraint.constant = size
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
        
        self.viewBack.layer.borderColor = self.bottomConstraint == nil ? UIColor.lightGrayColor().CGColor : UIColor(red: 205, green: 205, blue: 205).CGColor
        self.viewBack.layer.borderWidth = 1
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
