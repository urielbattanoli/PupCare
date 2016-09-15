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
        orderPromotionAsPfObject["price"] = data["price"]
        
        orderPromotionAsPfObject.saveInBackground { (success, error) in
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
    
    func checkIfCardIsValid(_ cardNumber : String, callback: @escaping (Int) -> Void) {
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
    
    func startTransaction(_ value: Double, cardInfo: [String:AnyObject], callback: @escaping (String,PFObject) -> Void){
        
        self.generateTrackId { (trackId) in
            
            let parameters : [String:AnyObject] = ["PaymentType":"01" as AnyObject,"CurrencyCode":"986" as AnyObject,"Value":value as AnyObject,"TrackId":trackId.objectId! as AnyObject,"Description":"PupCare Test Transaction" as AnyObject,"CardInfo":cardInfo as AnyObject]
            
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
    
    func confirmTransaction(_ trackId: String, acquirerTransactionId: String, cardBrand: Int, callback: @escaping (Bool,String) -> Void){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId as AnyObject,"PaymentType":"01" as AnyObject,"CardBrand":cardBrand as AnyObject, "TrackId":trackId as AnyObject]
        
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
    
    func cancelTransaction(_ trackId: String, acquirerTransactionId: String, cardBrand: Int, callback: @escaping (Bool,String) -> ()){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId as AnyObject,"PaymentType":"01" as AnyObject,"CardBrand":cardBrand as AnyObject, "TrackId":trackId as AnyObject]
        
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
    
    func getTransactionByTrackId(_ trackId : String){
        
        let transactionUrl = "\(GetTransactionByTrackIdUrl)\(trackId)"
        
        Alamofire.request(.GET, transactionUrl, parameters: nil, headers: self.requestHeaders)
            .response { request, response, data, error in
                print(request)
                
                let dataToString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Get Transaction")
                print(dataToString!)
        }
    }
    
    func generateTrackId(_ response:@escaping (PFObject)->()){
        let trackId = PFObject(className: "TrackTransaction")
        
        trackId.saveInBackground { (success, error) in
            response(trackId)
        }
    }
    
    func getOrderList(_ block: @escaping ([Order])->()) {
        let params = ["userId" : PFUser.current()!.objectId!]
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
}
