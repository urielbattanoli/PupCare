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

class AddCardViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var backgroundCardView: UIControl!
    
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
    var dateSelected = NSDate()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Adicionar cartão"
        
        self.backgroundCardView.layer.cornerRadius = 10
        
        if let card = self.card{
            self.title = "Editar cartão"
            
            self.lblCardNumber.text = card.number.numberCardMask()
            self.lblDateCard.text = card.expirationDate
            self.lblNameCard.text = card.name
            self.imageBrandCard.image = UIImage(named: card.number.brandCard())
            
            self.btAddCard.setTitle("Salvar mudanças", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func didEditingChanged(textField: UITextField) {
        switch textField {
        case self.txtFieldCardNumber:
            self.lblCardNumber.text = textField.text?.numberCardMask()
            let imageName = textField.text?.brandCard()
            if imageName != ""{
                self.imageBrandCard.image = UIImage(named: imageName!)
            }
            else{
                self.imageBrandCard.image = nil
            }
        case self.txtFieldNameCard:
            self.lblNameCard.text = textField.text
        default:
            print("case default textfield")
        }
    }
    
    @IBAction func didPressDate(textField: UITextField) {
        let datePickerView = MonthYearPickerView()
        
        datePickerView.onDateSelected = {(month: Int, year: Int) in
            let month = String(format: "%02d/", month)
            let year = String(format: "%d", year)
            
            self.lblDateCard.text = "VAL \(month)\(year.substringFromIndex(year.startIndex.advancedBy(2)))"
            textField.text = month+year
        }
        textField.inputView = datePickerView
    }
    
    @IBAction func didPressAddCard(sender: AnyObject) {
        if !self.validateFields(){
            return
        }
        var newCard: Card!
        if let card = self.card{
            self.editCard()
            newCard = card
        }
        else{
            let data = ["number":self.txtFieldCardNumber.text!,
                        "expirationDate":self.lblDateCard.text!,
                        "name":self.lblNameCard.text!]
            newCard = Card(data: data)
        }
        self.delegate?.cardDidAdded?(newCard)
        CardManager.sharedInstance.saveNewUserCard(newCard) { (sucess) in
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func didPressOnView(sender: UIControl) {
        self.dismissKeyboard()
    }
    
    //MARK: Textfield delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case self.txtFieldCardNumber where string != String():
            return textField.text!.characters.count < 16
        default:
            return true
        }
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.paste(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    //MARK: Functions
    func editCard(){
        if !self.validateFields(){
            return
        }
        if let card = self.card{
            // if change number
            if((self.txtFieldCardNumber.text != self.card?.number) && (self.txtFieldCardNumber.text != "")){
                card.number = self.txtFieldCardNumber.text!
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
    
    func validateFields() -> Bool{
        if self.txtFieldCardNumber.text == "" || self.txtFieldDateCard.text == "" || self.txtFieldNameCard.text == ""{
            self.showAlertCardNotValid(.obrigatoryFields)
            return false
        }
        if self.imageBrandCard.image == nil{
            self.showAlertCardNotValid(.cardNotValid)
            return false
        }
        return true
    }
    
    func showAlertCardNotValid(type: typeAlert){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let cancelBt = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(cancelBt)
        switch type {
        case .obrigatoryFields:
            alert.title = ""
            alert.message = ""
        
        case .cardNotValid:
            alert.title = ""
            alert.message = ""
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    enum typeAlert{
        case obrigatoryFields
        case cardNotValid
    }
}