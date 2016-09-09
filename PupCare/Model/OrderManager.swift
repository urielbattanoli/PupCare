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
import SwiftyJSON

class OrderManager: NSObject {
    
    static let sharedInstance = OrderManager()
    
    private let authorizationHeader : String = "pupcare:0tx#8yKY"
    private var authorizationHeaderToIso : String
    private var authorizationHeaderData : NSData
    private var authorizationHeaderDataToBase64 : String
    
    private let apiKeyHeader : String = "mHr2b6dCnHIAUpwZD562LD7Ksvc7wfFpslwlKS83AyARL/Hi"
    
    private var requestHeaders : [String:String]
    
    private let GetCardBrandUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Card/GetAvailableCardBrands"
    private let ValidateCardNumberUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Card/ValidateCardNumber"
    private let StartTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/StartTransaction"
    private let GetTransactionByTrackIdUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/Find/"
    private let ConfirmTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/ConfirmTransaction"
    private let CancelTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/CancelTransaction"
    
    override init(){
        authorizationHeaderToIso = authorizationHeader.stringByReplacingPercentEscapesUsingEncoding(NSISOLatin1StringEncoding)!
        authorizationHeaderData = authorizationHeaderToIso.dataUsingEncoding(NSISOLatin1StringEncoding)!
        authorizationHeaderDataToBase64 = authorizationHeaderData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        requestHeaders = ["Authorization":"Basic \(authorizationHeaderDataToBase64)",
                          "X-ApiKey":apiKeyHeader]
    }
    
    func saveOrder(order: [String:AnyObject], callback: (PFObject)->()){
        let orderAsPfObject = PFObject(className: "Order")
        orderAsPfObject.setObject(PFUser.currentUser()!, forKey: "userId")
        orderAsPfObject["userId"] = PFUser.currentUser()
        orderAsPfObject["trackId"] = order["trackId"] as! PFObject
        orderAsPfObject["price"] = order["price"]
        orderAsPfObject["petShopId"] = PFObject(withoutDataWithClassName: "PetShop", objectId: order["petShop"] as? String)
        orderAsPfObject["shipment"] = order["shipment"]
        
        
        orderAsPfObject.saveInBackgroundWithBlock { (success, error) in
            callback(orderAsPfObject)
        }
    }
    
    func saveProductsFromOrder(data: [String:AnyObject]){
        let orderProductAsPfObject = PFObject(className: "Order_Product")
        orderProductAsPfObject["orderId"] = data["orderId"] as! PFObject
        orderProductAsPfObject["productId"] = PFObject(withoutDataWithClassName: "Product", objectId: data["productId"] as? String)
        orderProductAsPfObject["quantity"] = data["quantity"]
        orderProductAsPfObject["price"] = data["price"]
        
        orderProductAsPfObject.saveInBackgroundWithBlock { (success, error) in
            print("salvou")
        }
    }
    
    func savePromotionsFromOrder(data: [String:AnyObject]){
        let orderPromotionAsPfObject = PFObject(className: "Order_Promotion")
        orderPromotionAsPfObject["orderId"] = data["orderId"] as! PFObject
        orderPromotionAsPfObject["promotionId"] = PFObject(withoutDataWithClassName: "Promotion", objectId: data["promotionId"] as? String)
        orderPromotionAsPfObject["price"] = data["price"]
        
        orderPromotionAsPfObject.saveInBackgroundWithBlock { (success, error) in
            print("salvou")
        }
        
    }
    
    
    func getAvailableCardBrands(){
        print(requestHeaders)
        Alamofire.request(.GET, GetCardBrandUrl, parameters: nil, headers: requestHeaders)
            .response { request, response, data, error in
                print(request)
                
                let dataToString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Available Card Brands")
                print(dataToString!)
        }
    }
    
    func checkIfCardIsValid(cardNumber : String, callback: (Int) -> Void) {
        let parameters = ["CardNumber":cardNumber]
        
        Alamofire.request(.POST, ValidateCardNumberUrl, parameters: parameters, headers: requestHeaders)
            .response { request, response, data, error in
                print(request)
                let dataToJSON = JSON(data: data!)
                
                if dataToJSON["IsValid"].bool == true {
                    
                    let cardBrand: Int = (dataToJSON["CardBrand"].int)!
                    callback(cardBrand)
                    
                }
                
        }
    }
    
    func startTransaction(value: Double, cardInfo: [String:AnyObject], callback: (String,PFObject) -> Void){
        
        self.generateTrackId { (trackId) in
            
            let parameters : [String:AnyObject] = ["PaymentType":"01","CurrencyCode":"986","Value":value,"TrackId":trackId.objectId!,"Description":"PupCare Test Transaction","CardInfo":cardInfo]
            
            Alamofire.request(.POST, self.StartTransactionUrl, parameters: parameters, headers: self.requestHeaders)
                .response { request, response, data, error in
                    print(request)
                    
                    let dataToJSON = JSON(data: data!)
                    
                    //Ver se tem estoque
                    
                    if let cardBrand = cardInfo["CardBrand"] as? Int{
                        if dataToJSON["IsApproved"].bool == true {
                            self.confirmTransaction(trackId.objectId!, acquirerTransactionId: dataToJSON["AcquirerTransactionId"].string!, cardBrand: cardBrand, callback: { (success, message) in
                                
                                callback(message,trackId)
                            })
                        } else {
                            self.cancelTransaction(trackId.objectId!, acquirerTransactionId: dataToJSON["AcquirerTransactionId"].string!, cardBrand: cardBrand, callback: { (success, message) in
                                callback(message,trackId)
                            })
                        }
                    }
            }
        }
    }
    
    func confirmTransaction(trackId: String, acquirerTransactionId: String, cardBrand: Int, callback: (Bool,String) -> Void){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId,"PaymentType":"01","CardBrand":cardBrand, "TrackId":trackId]
        
        Alamofire.request(.POST, self.ConfirmTransactionUrl, parameters: parameters, headers: self.requestHeaders)
            .response { request, response, data, error in
                print(request)
                let dataToJSON = JSON(data: data!)
                
                if dataToJSON["IsConfirmed"].bool == true {
                    print("Approved")
                } else {
                    print("Voided")
                }
                
                callback(dataToJSON["IsConfirmed"].bool!,dataToJSON["Message"].string!)
        }
    }
    
    func cancelTransaction(trackId: String, acquirerTransactionId: String, cardBrand: Int, callback: (Bool,String) -> ()){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId,"PaymentType":"01","CardBrand":cardBrand, "TrackId":trackId]
        
        Alamofire.request(.POST, self.CancelTransactionUrl, parameters: parameters, headers: self.requestHeaders)
            .response { request, response, data, error in
                print(request)
                let dataToJSON = JSON(data: data!)
                
                if dataToJSON["IsRefunded"].bool == true {
                    print("Refunded")
                } else {
                    print("Voided")
                }
                
                callback(dataToJSON["IsRefunded"].bool!,dataToJSON["Message"].string!)
        }
    }
    
    func getTransactionByTrackId(trackId : String){
        
        let transactionUrl = "\(GetTransactionByTrackIdUrl)\(trackId)"
        
        Alamofire.request(.GET, transactionUrl, parameters: nil, headers: self.requestHeaders)
            .response { request, response, data, error in
                print(request)
                
                let dataToString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Get Transaction")
                print(dataToString!)
        }
    }
    
    func generateTrackId(response:(PFObject)->()){
        let trackId = PFObject(className: "TrackTransaction")
        
        trackId.saveInBackgroundWithBlock { (success, error) in
            response(trackId)
        }
    }
    
    func getOrderList(block: ([Order])->()) {
        let params = ["userId" : UserManager.sharedInstance.user!.userId!]
        PFCloud.callFunctionInBackground("getUserOrders", withParameters: params) { (objects, error) in
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
    
    func getOrderProducts(order: Order, block: ([Product])->()) {
        let params = ["orderId" : order.orderId]
        PFCloud.callFunctionInBackground("getOrderProducts", withParameters: params) { (objects, error) in
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
    
    func getOrderPromotions(order: Order, block: ([Promotion])->()){
        let params = ["orderId" : order.orderId]
        PFCloud.callFunctionInBackground("getOrderPromotions", withParameters: params) { (objects, error) in
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
