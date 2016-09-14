//
//  AddCardViewController.swift
//  PupCare
//
//  Created by Uriel Battanoli on 7/26/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import UIKit
@objc protocol AddCardDelegate {
    @objc optional func cardDidAdded(_ card: Card)
}

class AddCardViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblDateCard: UILabel!
    @IBOutlet weak var lblNameCard: UILabel!
    @IBOutlet weak var imageBrandCard: UIImageView!
    
    @IBOutlet weak var txtFieldCardNumber: UITextField!
    @IBOutlet weak var txtFieldDateCard: UITextField!
    @IBOutlet weak var txtFieldNameCard: UITextField!
    
    @IBOutlet weak var btAddCard: UIButton!
    
    weak var delegate : AddCardDelegate?
    
    //MARK: Variables
    var card: Card?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Adicionar cartão"
        
        
        if let card = self.card{
            self.title = "Editar cartão"
            
            self.lblCardNumber.text = card.number.numberCardMask()
            self.lblDateCard.text = card.expirationDate
            self.lblNameCard.text = card.name
            self.btAddCard.setTitle("Salvar mudanças", for: UIControlState())
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func didEditingChanged(_ textField: UITextField) {
        switch textField {
        case self.txtFieldCardNumber:
            self.lblCardNumber.text = textField.text//?.numberCardMask()
        case self.txtFieldNameCard:
            self.lblNameCard.text = textField.text
        default:
            print("case default textfield")
        }
    }
    
    @IBAction func didPressDate(_ textField: UITextField) {
        let datePickerView = MonthYearPickerView()
        datePickerView.onDateSelected = {(month: Int, year: Int) in
            let date = String(format: "%02d/%d", month, year)
            
            self.lblDateCard.text = date
            textField.text = date
        }
        textField.inputView = datePickerView
    }
    
    @IBAction func didPressAddCard(_ sender: AnyObject) {
        var newCard: Card!
        if let card = self.card{
            self.editCard()
            newCard = card
        }
        else{
            let data = ["number":self.txtFieldCardNumber.text!,
                        "expirationDate":self.lblDateCard.text!,
                        "name":self.lblNameCard.text!]
            newCard = Card(data: data as [String : AnyObject])
        }
        self.delegate?.cardDidAdded?(newCard)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Functions
    func editCard(){
        if let card = self.card{
            // if change number
            if((self.txtFieldCardNumber.text != self.card?.number) && (self.txtFieldCardNumber.text != "")){
            card.number = self.lblCardNumber.text!
            }
            // if change date
            if((self.txtFieldDateCard.text != self.card?.expirationDate) && (self.txtFieldDateCard.text != "")){
                card.expirationDate = self.lblDateCard.text!
            }
            // if change name
            if((self.txtFieldNameCard.text != self.card?.name) && (self.txtFieldNameCard.text != "")){
                card.name = self.lblNameCard.text!
            }
        }
    }
}
