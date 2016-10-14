//
//  ParseManager.swift
//  PupCare
//
//  Created by Anderson Rogério da Silva Gralha on 7/11/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import ParseFacebookUtilsV4


class ParseManager {
    
    static func InitParse(_ launchOptions: [AnyHashable: Any]?) {
        let configuration = ParseClientConfiguration {
            $0.applicationId = "dckKugdRir32iGpqm561bgmwmxEBxR3wEnKtKodD"
            $0.clientKey = "4jZKylHLUj9WNFu304CQltMuYM8aoJTiocHfMBTU"
            //$0.server = "http://ec2-54-191-28-37.us-west-2.compute.amazonaws.com:1337/upper"
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: configuration)
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
    }
    
    static func InitParseForUnitTest(){
        let configuration = ParseClientConfiguration {
            $0.applicationId = "dckKugdRir32iGpqm561bgmwmxEBxR3wEnKtKodD"
            $0.clientKey = "4jZKylHLUj9WNFu304CQltMuYM8aoJTiocHfMBTU"
            //$0.server = "http://ec2-54-191-28-37.us-west-2.compute.amazonaws.com:1337/upper"
            $0.isLocalDatastoreEnabled = true
        }
        Parse.initialize(with: configuration)

    }
}
