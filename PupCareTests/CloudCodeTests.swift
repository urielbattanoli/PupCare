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
    
    fileprivate let expectationTime : TimeInterval = 10.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPromotionsQuery(){
        let expectation: XCTestExpectation = self.expectation(description: "Promotions query completed with no errors")
        
        PromotionManager.sharedInstance.getPromotionsList(10, longitude: 10, withinKilometers: 10) { (promotions, error) in
            XCTAssertNotNil(promotions)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: expectationTime, handler: nil)
    }
    
    func testPromotionDetailsQuery(){
        let expectation: XCTestExpectation = self.expectation(description: "Promotion Details query completed with no errors")
        
        var promotion : Promotion?
        
        PromotionManager.sharedInstance.getPromotionsList(10, longitude: 10, withinKilometers: 10) { (promotions, error) in
            promotion = promotions![0]
            
            PromotionManager.sharedInstance.getPromotionDetails((promotion)!, response: { (promotionDetails, error) in
                XCTAssertNotNil(promotionDetails)
                expectation.fulfill()
            })
        }
        
        waitForExpectations(timeout: expectationTime, handler: nil)
    }

    func testProductQuery(){
        //ERROR - NEEDS FIX
        let expectation : XCTestExpectation = self.expectation(description: "Product query completed with no errors")
        
        var petshop : PetShop?
        
        PetShopManager.sharedInstance.getNearPetShops(10, longitude: 10, withinKilometers: 10) { (petshops, error) in
            XCTAssertNotNil(petshops)
            petshop = petshops![0]
            
            ProductManager.sharedInstance.getProductList((petshop?.objectId)!) { (products) in
                XCTAssertNotNil(products)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: expectationTime, handler: nil)
    }
    
    func testNearbyPetShopQuery(){
        let expectation : XCTestExpectation = self.expectation(description: "PetShop query completed with no errors")
        
        PetShopManager.sharedInstance.getNearPetShops(10, longitude: 10, withinKilometers: 10) { (petshops, error) in
            XCTAssertNotNil(petshops)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: expectationTime, handler: nil)
    }
    
    func testOrderQuery(){
        //ERROR - NEEDS FIX
        let expectation : XCTestExpectation = self.expectation(description: "Order query completed with no errors")
        OrderManager.sharedInstance.getOrderList { (orders) in
            XCTAssertNotNil(orders)
            
            OrderManager.sharedInstance.getOrderProducts(orders[0], block: { (products) in
                XCTAssertNotNil(products)
                expectation.fulfill()
            })
        }
        waitForExpectations(timeout: expectationTime, handler: nil)
    }
    
    func testTransactionsFlow(){
        let transactionExpectation : XCTestExpectation = expectation(description: "Transaction flow completed with no errors")
        let cardExpectation : XCTestExpectation = expectation(description: "CardNumber completed with no errors")
        let trackExpectation : XCTestExpectation = expectation(description: "TrackGen completed with no errors")
        
        
        var cartao: [String: AnyObject] = [:]
        cartao["CardHolderName"] = "Rebecca Sommers" as AnyObject?
        cartao["CardNumber"] = "4012001038166662" as AnyObject?
        cartao["CVV"] = "456" as AnyObject?
        cartao["ExpirationYear"] = 2017 as AnyObject?
        cartao["ExpirationMonth"] = 04 as AnyObject?
        
        OrderManager.sharedInstance.generateTrackId { (object) in
            XCTAssertNotNil(object)
            trackExpectation.fulfill()
        }
        
        OrderManager.sharedInstance.checkIfCardIsValid(cartao["CardNumber"] as! String) { (result) in
            XCTAssertNotNil(result)
            cartao["CardBrand"] = result as AnyObject?
            cardExpectation.fulfill()
        }
        
        OrderManager.sharedInstance.startTransaction(40.0, cardInfo: cartao) { (message, object) in
            XCTAssertEqual(message, "Confirmed")
            transactionExpectation.fulfill()
        }
        
        
        
        waitForExpectations(timeout: expectationTime, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
