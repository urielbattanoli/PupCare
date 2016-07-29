//
//  AddCardViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/26/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
@objc protocol AddCardDelegate {
    optional func cardDidAdded(card: Card)
}

class AddCardViewController: UIViewController {

    //Mark: Outlets
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblDateCard: UILabel!
    @IBOutlet weak var lblNameCard: UILabel!
    @IBOutlet weak var imageBrandCard: UIImageView!
    
    @IBOutlet weak var txtFieldCardNumber: UITextField!
    @IBOutlet weak var txtFieldDateCard: UITextField!
    @IBOutlet weak var txtFieldNameCard: UITextField!
    
    weak var delegate : AddCardDelegate?
    
    //Mark: Variables
    var card: Card?
    
    //Mark: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let card = self.card{
            self.lblCardNumber.text = "\(card.number)"
            self.lblDateCard.text = "\(card.expirationDate)"
            self.lblNameCard.text = card.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Actions
    @IBAction func didEditingChanged(textField: UITextField) {
        switch textField {
        case self.txtFieldCardNumber:
            self.lblCardNumber.text = textField.text
        case self.txtFieldDateCard:
            self.lblDateCard.text = textField.text
        case self.txtFieldNameCard:
            self.lblNameCard.text = textField.text
        default:
            print("case default textfield")
        }
    }
    
    @IBAction func didPressDate(textField: UITextField) {
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.date
    }
    
    @IBAction func didPressAddCard(sender: AnyObject) {
        let data = ["number":self.lblCardNumber.text!,
                    "expirationDate":self.lblDateCard.text!,
                    "name":self.lblNameCard.text!]
        let newCard = Card(data: data)
        self.delegate?.cardDidAdded?(newCard)
        self.navigationController?.popViewControllerAnimated(true)
    }
}