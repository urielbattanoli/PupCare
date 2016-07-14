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
                self.textField.text = string
            }
        }
    }
    
    var corner: CGFloat?{
        didSet{
            if let view = self.viewBack{
                view.layer.masksToBounds = true
                view.layer.cornerRadius = self.corner!
            }
        }
    }
    
    func changeConstraintSize(size: CGFloat) {
        if let constraint = self.bottomConstraint{
            constraint.constant = size
        }
    }
    
    func setCorner() {
        self.corner = 5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
