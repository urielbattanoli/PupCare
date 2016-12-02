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
    
    
    func testAddProduct() {
        let app = XCUIApplication()
        app.tabBars.buttons["Minha Conta"].tap()
        app.buttons["Entrar com sua conta"].tap()
        
        let digiteSeuEMailTextField = app.textFields["Digite seu e-mail"]
        digiteSeuEMailTextField.tap()
        
        digiteSeuEMailTextField.typeText("teste@teste.com")
        
        let digiteSuaSenhaSecureTextField = app.secureTextFields["Digite sua senha"]
        digiteSuaSenhaSecureTextField.tap()
        digiteSuaSenhaSecureTextField.typeText("123456")
        
        app.buttons["Fazer login"].tap()
        
        app.tabBars.buttons["Pet Shops"].tap()
        
        app.tables.cells.element(boundBy: 0).tap()
        
        app.tables.cells.element(boundBy: 0).tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element
        element.swipeUp()
        
        app.sliders["0%"].swipeRight()
        
        app.buttons["Adicionar ao carrinho"].tap()
        
        app.buttons["Ver seu carrinho"].tap()
        
        app.tables.buttons["Finalizar compra para esta Pet Shop"].tap()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["Retira na pet shop"].tap()
        tablesQuery.staticTexts["Cartão"].tap()
        tablesQuery.staticTexts["Dinheiro"].tap()
        
        //BACK TO MAIN SCREEN
        app.navigationBars["Finalizar compra"].buttons["Voltar"].tap()
        app.navigationBars["Carrinho"].buttons["Fechar"].tap()
        
        app.tabBars.buttons["Minha Conta"].tap()
        app.tables.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element.tap()
    }
    
    func testOrder() {
        let app = XCUIApplication()
        app.tabBars.buttons["Minha Conta"].tap()
        app.buttons["Entrar com sua conta"].tap()
        
        let digiteSeuEMailTextField = app.textFields["Digite seu e-mail"]
        digiteSeuEMailTextField.tap()
        
        digiteSeuEMailTextField.typeText("teste@teste.com")
        
        let digiteSuaSenhaSecureTextField = app.secureTextFields["Digite sua senha"]
        digiteSuaSenhaSecureTextField.tap()
        digiteSuaSenhaSecureTextField.typeText("123456")
        
        app.buttons["Fazer login"].tap()
        
        app.tabBars.buttons["Pedidos"].tap()
        app.tables.buttons["Ver detalhes do pedido"].tap()
        
        app.tabBars.buttons["Minha Conta"].tap()
        app.tables.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element.tap()
    }
    
    func testAddAddress() {
        let app = XCUIApplication()
        app.tabBars.buttons["Minha Conta"].tap()
        app.buttons["Entrar com sua conta"].tap()
        
        let digiteSeuEMailTextField = app.textFields["Digite seu e-mail"]
        digiteSeuEMailTextField.tap()
        
        digiteSeuEMailTextField.typeText("teste@teste.com")
        
        let digiteSuaSenhaSecureTextField = app.secureTextFields["Digite sua senha"]
        digiteSuaSenhaSecureTextField.tap()
        digiteSuaSenhaSecureTextField.typeText("123456")
        
        app.buttons["Fazer login"].tap()
        
        app.tabBars.buttons["Minha Conta"].tap()
        
        app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.tap()
        app.tables.staticTexts["Adicionar novo endereço"].tap()
        
        app.buttons["Buscar pelo CEP"].tap()
        
        let buscarEndereOPeloCepAlert = app.alerts["Buscar endereço pelo CEP"]
        let ex90008890TextField = buscarEndereOPeloCepAlert.collectionViews.textFields["Ex: 90008890"]
        ex90008890TextField.typeText("90680430")
        buscarEndereOPeloCepAlert.buttons["Done"].tap()
        
        let nMeroTextField = app.textFields["Número"]
        nMeroTextField.tap()
        nMeroTextField.typeText("229")
        
        app.buttons["Cadastrar Endereço"].tap()
        
        //TEST REMOVE ADDRESS
        app.tables.staticTexts["Rua Graciano Azambuja"].swipeLeft()
        app.tables.buttons["Remover"].tap()
        
        app.tables.children(matching: .cell).element(boundBy: 6).children(matching: .textField).element.tap()
    }
}
