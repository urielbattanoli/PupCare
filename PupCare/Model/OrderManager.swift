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
    
    func checkIfCardIsValid(cardNumber : String){
        let parameters = ["CardNumber":cardNumber]
        
        Alamofire.request(.POST, ValidateCardNumberUrl, parameters: parameters, headers: requestHeaders)
            .response { request, response, data, error in
                print(request)
                
                let dataToString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Valid Card Number")
                print(dataToString!)
        }
    }
    
    func startTransaction(value: Double, cardInfo: [String:AnyObject]){
        
        self.generateTrackId { (trackId) in
            
            let parameters : [String:AnyObject] = ["PaymentType":"01","CurrencyCode":"986","Value":value,"TrackId":trackId,"Description":"PupCare Test Transaction","CardInfo":cardInfo]
            
            Alamofire.request(.POST, self.StartTransactionUrl, parameters: parameters, headers: self.requestHeaders)
                .response { request, response, data, error in
                    print(request)
                    
                    let dataToJSON = JSON(data!)
                    
                    if dataToJSON["isApproved"].bool == true {
                        
                        //Ver se tem estoque
                        
                        if let cardBrand = cardInfo["CardBrand"] as? String{
                            self.confirmTransaction(dataToJSON["TrackId"].string!, acquirerTransactionId: dataToJSON["AcquirerTransactionId"].string!, cardBrand: cardBrand)
                        }
                    } else {
                        if let cardBrand = cardInfo["CardBrand"] as? String{
                            self.cancelTransaction(dataToJSON["TrackId"].string!, acquirerTransactionId: dataToJSON["AcquirerTransactionId"].string!, cardBrand: cardBrand)
                        }
                    }
            }
        }
    }
    
    func confirmTransaction(trackId: String, acquirerTransactionId: String, cardBrand: String){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId,"PaymentType":"01","CardBrand":cardBrand, "TrackId":trackId]
        
        Alamofire.request(.POST, self.ConfirmTransactionUrl, parameters: parameters, headers: self.requestHeaders)
            .response { request, response, data, error in
                print(request)
                let dataToJSON = JSON(data!)
                
                if dataToJSON["isApproved"].bool == true {
                    print("Approved")
                    //Remover do estoque
                } else {
                    print("Voided")
                }
        }
    }
    
    func cancelTransaction(trackId: String, acquirerTransactionId: String, cardBrand: String){
        let parameters : [String:AnyObject] = ["AcquirerTransactionId":acquirerTransactionId,"PaymentType":"01","CardBrand":cardBrand, "TrackId":trackId]
        
        Alamofire.request(.POST, self.CancelTransactionUrl, parameters: parameters, headers: self.requestHeaders)
            .response { request, response, data, error in
                print(request)
                let dataToJSON = JSON(data!)
                
                if dataToJSON["isApproved"].bool == true {
                    print("Approved")
                    //Remover do estoque
                } else {
                    print("Voided")
                }
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
    
    func generateTrackId(response:(String)->()){
        let trackId = PFObject(className: "TrackTransaction")
        
        trackId.saveInBackgroundWithBlock { (success, error) in
            response(trackId.objectId!)
        }
    }
}
