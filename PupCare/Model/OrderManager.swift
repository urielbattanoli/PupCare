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
    private let GetTransactionUrl = "https://www.gatewaypaycode.com.br/Teste/WebApi/api/Transaction/"
    
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
    
    func chechIfCardIsValid(cardNumber : String){
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
                    
                    let dataToString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Start Transaction")
                    print(dataToString!)
            }
        }
    }
    
    func getTransaction(trackId : String){
        
        let transactionUrl = "\(GetTransactionUrl)\(trackId))"
        
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
