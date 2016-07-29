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

class OrderManager: NSObject {
    
    static let sharedInstance = OrderManager()
    
    private let authorizationHeader : String = "pupcare:0tx#8yKY"
    private var authorizationHeaderToIso : String
    private var authorizationHeaderData : NSData
    private var authorizationHeaderDataToBase64 : String
    
    private let apiKeyHeader : String = "pupcare"
    
    private var requestHeaders : [String:AnyObject]
    
    private let GetCardBrandUrl = "http://169.57.143.181:8080/WebApi/Card/GetAvailableCardBrands"
    
    override init(){
        authorizationHeaderToIso = authorizationHeader.stringByReplacingPercentEscapesUsingEncoding(NSISOLatin1StringEncoding)!
        authorizationHeaderData = authorizationHeaderToIso.dataUsingEncoding(NSISOLatin1StringEncoding)!
        authorizationHeaderDataToBase64 = authorizationHeaderData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        requestHeaders = ["Authorization":"Basic \(authorizationHeaderDataToBase64)",
                          "X-ApiKey":apiKeyHeader]
    }
    
    func getAvailableCardBrands(){
        Alamofire.request(.GET, GetCardBrandUrl, parameters: requestHeaders)
            .response { request, response, data, error in
                print(request)
                print(response)
                print(error)
        }
    }
}
