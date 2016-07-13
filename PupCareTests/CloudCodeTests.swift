//
//  CloudCodeTests.swift
//  PupCare
//
//  Created by Luis Filipe Campani on 12/07/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import XCTest

@testable import PupCare

class CloudCodeTests: XCTestCase {
    
    private let expectationTime : NSTimeInterval = 10.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ParseManager.InitParse()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPromotionsQuery(){
        let expectation: XCTestExpectation = expectationWithDescription("Promotions query completed with no errors")
        
        PromotionManager.getPromotionsList(10, longitude: 10, withinKilometers: 10) { (promotions, error) in
            XCTAssertNotNil(promotions)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(expectationTime, handler: nil)
    }
    
    func testPromotionDetailsQuery(){
        let expectation: XCTestExpectation = expectationWithDescription("Promotion Details query completed with no errors")
        
        var promotion : Promotion?
        
        PromotionManager.getPromotionsList(10, longitude: 10, withinKilometers: 10) { (promotions, error) in
            promotion = promotions![0]
            
            PromotionManager.getPromotionDetails((promotion?.objectId)!, response: { (promotionDetails, error) in
                XCTAssertNotNil(promotionDetails)
                expectation.fulfill()
            })
        }
        
        waitForExpectationsWithTimeout(expectationTime, handler: nil)
    }

    func testProductQuery(){
        let expectation : XCTestExpectation = expectationWithDescription("Product query completed with no errors")
        
        var petshop : PetShop?
        
        PetShopManager.getNearPetShops(10, longitude: 10, withinKilometers: 10) { (petshops, error) in
            XCTAssertNotNil(petshops)
            petshop = petshops![0]
            
            ProductManager.getProductList((petshop?.objectId)!) { (products) in
                XCTAssertNotNil(products)
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(expectationTime, handler: nil)
    }
    
    func testNearbyPetShopQuery(){
        let expectation : XCTestExpectation = expectationWithDescription("PetShop query completed with no errors")
        
        PetShopManager.getNearPetShops(10, longitude: 10, withinKilometers: 10) { (petshops, error) in
            XCTAssertNotNil(petshops)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(expectationTime, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
