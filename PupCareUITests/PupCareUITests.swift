//
//  PupCareUITests.swift
//  PupCareUITests
//
//  Created by Uriel Battanoli on 6/10/16.
//  Copyright © 2016 PupCare. All rights reserved.
//

import XCTest

class PupCareUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func testLogin(){
//        
//        
//        let app = XCUIApplication()
//        app.tabBars.buttons["Minha Conta"].tap()
//        app.buttons["Entrar com sua conta"].tap()
//        
//        let digiteSeuEMailTextField = app.textFields["Digite seu e-mail"]
//        digiteSeuEMailTextField.tap()
//    
//        digiteSeuEMailTextField.typeText("k")
//        digiteSeuEMailTextField.typeText("e")
//        digiteSeuEMailTextField.typeText("k")
//        digiteSeuEMailTextField.typeText("e")
//        digiteSeuEMailTextField.typeText("@")
//        digiteSeuEMailTextField.typeText("g")
//        digiteSeuEMailTextField.typeText("m")
//        digiteSeuEMailTextField.typeText("a")
//        digiteSeuEMailTextField.typeText("i")
//        digiteSeuEMailTextField.typeText("l")
//        digiteSeuEMailTextField.typeText(".")
//        digiteSeuEMailTextField.typeText("c")
//        digiteSeuEMailTextField.typeText("o")
//        digiteSeuEMailTextField.typeText("m")
//        
//
//        let digiteSuaSenhaSecureTextField = app.secureTextFields["Digite sua senha"]
//        digiteSuaSenhaSecureTextField.tap()
//        digiteSuaSenhaSecureTextField.typeText("q")
//        digiteSuaSenhaSecureTextField.typeText("w")
//        digiteSuaSenhaSecureTextField.typeText("e")
//        digiteSuaSenhaSecureTextField.typeText("r")
//        digiteSuaSenhaSecureTextField.typeText("t")
//        digiteSuaSenhaSecureTextField.typeText("y")
//        app.buttons["Fazer login"].tap()
//        app.tabBars.buttons["Minha Conta"].tap()
//        
//        let tablesQuery = app.tables
//        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.tap()
//        tablesQuery.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element.tap()
//        
//        
//    }
    
    func testAddProductToCart(){
        
        let app = XCUIApplication()
        
        app.tabBars.buttons["Pet Shops"].tap()
        
        let cell = app.tables.cells
        
        cell.element(boundBy: 0).tap()
        
        app.tables.staticTexts["Ração Crocante"].tap()
        app.sliders["0%"].press(forDuration: 2.5);
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        app.sliders["0%"].swipeRight()
        
        
        app.buttons["Adicionar ao carrinho"].tap()
    }
    
}
