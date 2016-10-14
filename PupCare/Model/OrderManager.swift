//
//  OrderManager.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 27/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Parse
import Gloss

struct CheckIfValidCard : Decodable {
    let IsValid : Bool!
    let Message : String!
    let CardBrand : Int!
    
    init?(json: JSON){
        self.IsValid = "IsValid" <~~ json
        self.Message = "Message" <~~ json
        self.CardBrand = "CardBrand" <~~ json
    }
}

struct StartTransaction : Decodable {
    let IsApproved : Bool!
    let ResultCode : String!
    let AcquirerTransactionId : String!
    let Message : String!
    let PayCodeTransactionId : Int!
    
    init?(json: JSON){
        self.IsApproved = "IsApproved" <~~ json
        self.ResultCode = "ResultCode" <~~ json
        self.AcquirerTransactionId = "AcquirerTransactionId" <~~ json
        self.Message = "Message" <~~ json
        self.PayCodeTransactionId = "PayCodeTransactionId" <~~ json
    }
}

struct ConfirmTransaction : Decodable {
    let IsConfirmed : Bool!
    let ResultCode : String!
    let AcquirerTransactionId : String!
    let Message : String!
    let PayCodeTransactionId : Int!
    
    init?(json: JSON){
        self.IsConfirmed = "IsConfirmed" <~~ json
        self.ResultCode = "ResultCode" <~~ json
        self.AcquirerTransactionId = "AcquirerTransactionId" <~~ json
        self.Message = "Message" <~~ json
        self.PayCodeTransactionId = "PayCodeTransactionId" <~~ json
    }
}

struct CancelTransaction {
    let IsRefunded : Bool!
    let ResultCode : String!
    let AcquirerTransactionId : String!
    let Message : String!
    let PayCodeTransactionId : Int!
    
    init?(json: JSON){
        self.IsRefunded = "IsRefunded" <~~ json
        self.ResultCode = "ResultCode" <~~ json
        self.AcquirerTransactionId = "AcquirerTransactionId" <~~ json
        self.Message = "Message" <~~ json
        self.PayCodeTransactionId = "PayCodeTransactionId" <~~ json
    }
}

class OrderManager: NSObject {
    
    static let sharedInstance = OrderManager()
    
    fileprivate let authorizationHeader : String = "pupcare:0tx#8yKY"
    fileprivate var authorizationHeaderToIso : String
    fileprivate var authorizationHeaderData : Data
    fileprivate var authorizationHeaderDataToBase64 : String
    
    fileprivate let apiKeyHeader : String = "mHr2b6dCnHIAUpwZD562LD7Ksvc7wfFpslwlKS83AyARL/Hi"
    
    fileprivate var requestHeaders : [String:String]
    
    fileprivate let GetCardBrandUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Card/GetAvailableCardBrands"
    fileprivate let ValidateCardNumberUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Card/ValidateCardNumber"
    fileprivate let StartTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/StartTransaction"
    fileprivate let GetTransactionByTrackIdUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/Find/"
    fileprivate let ConfirmTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/ConfirmTransaction"
    fileprivate let CancelTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/CancelTransaction"
    
    override init(){
        authorizationHeaderToIso = authorizationHeader.replacingPercentEscapes(using: String.Encoding.isoLatin1)!
        authorizationHeaderData = authorizationHeaderToIso.data(using: String.Encoding.isoLatin1)!
        authorizationHeaderDataToBase64 = authorizationHeaderData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        requestHeaders = ["Authorization":"Basic \(authorizationHeaderDataToBase64)",
                          "X-ApiKey":apiKeyHeader]
    }
    
    func saveOrder(_ order: [String:AnyObject], callback: @escaping (PFObject)->()){
        let orderAsPfObject = PFObject(className: "Order")
        orderAsPfObject.setObject(PFUser.current()!, forKey: "userId")
        orderAsPfObject["userId"] = PFUser.current()
        orderAsPfObject["trackId"] = order["trackId"] as! PFObject
        orderAsPfObject["price"] = order["price"]
        orderAsPfObject["petShopId"] = PFObject(withoutDataWithClassName: "PetShop", objectId: order["petShop"] as? String)
        orderAsPfObject["shipment"] = order["shipment"]
        orderAsPfObject["addressId"] = PFObject(withoutDataWithClassName: "Address", objectId: order["addressId"] as? String)
        orderAsPfObject["paymentMethod"] = order["paymentMethod"]
        
        orderAsPfObject.saveInBackground { (success, error) in
            callback(orderAsPfObject)
        }
    }
    
    func saveProductsFromOrder(_ data: [String:AnyObject]){
        let orderProductAsPfObject = PFObject(className: "Order_Product")
        orderProductAsPfObject["orderId"] = data["orderId"] as! PFObject
        orderProductAsPfObject["productId"] = PFObject(withoutDataWithClassName: "Product", objectId: data["productId"] as? String)
        orderProductAsPfObject["quantity"] = data["quantity"]
        orderProductAsPfObject["price"] = data["price"]
        
        orderProductAsPfObject.saveInBackground { (success, error) in
            print("salvou")
        }
    }
    
    func savePromotionsFromOrder(_ data: [String:AnyObject]){
        let orderPromotionAsPfObject = PFObject(className: "Order_Promotion")
        orderPromotionAsPfObject["orderId"] = data["orderId"] as! PFObject
        orderPromotionAsPfObject["promotionId"] = PFObject(withoutDataWithClassName: "Promotion", objectId: data["promotionId"] as? String)
        orderPromotionAsPfObject["quantity"] = data["quantity"]
        orderPromotionAsPfObject["price"] = data["price"]
        
        orderPromotionAsPfObject.saveInBackground { (success, error) in
            print("salvou")
        }
        
    }
    
    func checkIfCardIsValid(_ cardNumber : String, callback: @escaping (Int) -> Void) {
        let parameters = ["CardNumber":cardNumber]
        
        Alamofire.request(self.ValidateCardNumberUrl, method: .post, parameters: parameters).responseJSON { (response) in
            if let JSON = response.result.value as? JSON{
                let checkIfValidCard = CheckIfValidCard(json: JSON)!
                
                if checkIfValidCard.IsValid == true {
                    callback(checkIfValidCard.CardBrand)
                }
                
            }
        }
    }
    
    func startTransaction(_ value: Double, cardInfo: [String:AnyObject], callback: @escaping (String,PFObject) -> Void){
        
        self.generateTrackId { (trackId) in
            
            let parameters : [String:AnyObject] = ["PaymentType":"01" as AnyObject,"CurrencyCode":"986" as AnyObject,"Value":value as AnyObject,"TrackId":trackId.objectId! as AnyObject,"Description":"PupCare Test Transaction" as AnyObject,"CardInfo":cardInfo as AnyObject]
            
            Alamofire.request(self.StartTransactionUrl, method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                if let JSON = response.result.value as? JSON{
                    let startTranscation = StartTransaction(json: JSON)!
                    
                    if let cardBrand = cardInfo["CardBrand"] as? Int{
                        if startTranscation.IsApproved == true {
                            self.confirmTransaction(trackId.objectId!, acquirerTransactionId: startTranscation.AcquirerTransactionId, cardBrand: cardBrand, callback: { (success, message) in
                                
                                callback(message,trackId)
                            })
                        } else {
                            self.cancelTransaction(trackId.objectId!, acquirerTransactionId: startTranscation.AcquirerTransactionId, cardBrand: cardBrand, callback: { (success, message) in
                                callback(message,trackId)
                            })
                        }
                    }
                }
            })
        }
    }
    
    func confirmTransaction(_ trackId: String, acquirerTransactionId: String, cardBrand: Int, callback: @escaping (Bool,String) -> Void){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId as AnyObject,"PaymentType":"01" as AnyObject,"CardBrand":cardBrand as AnyObject, "TrackId":trackId as AnyObject]
        
        Alamofire.request(self.ConfirmTransactionUrl, method: .post, parameters: parameters).responseJSON { (response) in
            if let JSON = response.result.value as? JSON{
                let confirmTransaction = ConfirmTransaction(json: JSON)!
                
                if confirmTransaction.IsConfirmed == true{
                    print("Approved")
                } else {
                    print("Voided")
                }
                callback(confirmTransaction.IsConfirmed ,confirmTransaction.Message)
            }
        }
    }
    
    func cancelTransaction(_ trackId: String, acquirerTransactionId: String, cardBrand: Int, callback: @escaping (Bool,String) -> ()){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId as AnyObject,"PaymentType":"01" as AnyObject,"CardBrand":cardBrand as AnyObject, "TrackId":trackId as AnyObject]
        
        Alamofire.request(self.CancelTransactionUrl, method: .post, parameters: parameters).responseJSON { (response) in
            if let JSON = response.result.value as? JSON{
                let cancelTransaction = CancelTransaction(json: JSON)!
                
                if cancelTransaction.IsRefunded == true{
                    print("Refunded")
                } else {
                    print("Voided")
                }
                callback(cancelTransaction.IsRefunded ,cancelTransaction.Message)
            }
        }
    }
    
    func getTransactionByTrackId(_ trackId : String){
        
        let transactionUrl = "\(GetTransactionByTrackIdUrl)\(trackId)"
        
        Alamofire.request(transactionUrl).responseString(completionHandler: { (response) in
            print(response)
        })
    }
    
    func generateTrackId(_ response:@escaping (PFObject)->()){
        let trackId = PFObject(className: "TrackTransaction")
        
        trackId.saveInBackground { (success, error) in
            response(trackId)
        }
    }
    
    func getOrderList(_ block: @escaping ([Order])->()) {
        let params = ["userId" : UserManager.sharedInstance.user!.userId!]
        PFCloud.callFunction(inBackground: "getUserOrders", withParameters: params) { (objects, error) in
            var orders = [Order]()
            if let error = error{
                print(error)
                block(orders)
            }
            else{
                if let objects = objects as? [PFObject]{
                    for object in objects{
                        orders.append(Order(parseObject: object))
                    }
                    block(orders)
                }
            }
        }
    }
    
    func getOrderProducts(_ order: Order, block: @escaping ([Product])->()) {
        let params = ["orderId" : order.orderId]
        PFCloud.callFunction(inBackground: "getOrderProducts", withParameters: params) { (objects, error) in
            var products = [Product]()
            if let error = error{
                print(error)
                block(products)
            }
            else{
                if let objects = objects as? [PFObject]{
                    for object in objects{
                        products.append(Product(parseObject: object))
                    }
                    block(products)
                }
            }
        }
    }
    
    func getOrderPromotions(_ order: Order, block: @escaping ([Promotion])->()){
        let params = ["orderId" : order.orderId]
        PFCloud.callFunction(inBackground: "getOrderPromotions", withParameters: params) { (objects, error) in
            var promotions = [Promotion]()
            if let error = error{
                print(error)
                block(promotions)
            }
            else{
                if let objects = objects as? [PFObject]{
                    for object in objects{
                        promotions.append(Promotion(parseObject: object))
                    }
                    block(promotions)
                }
            }
        }
    }
}
