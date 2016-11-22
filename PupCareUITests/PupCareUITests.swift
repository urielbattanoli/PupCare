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

    func testAddAddress(){
        let app = XCUIApplication()
        app.tabBars.buttons["Minha Conta"].tap()
        app.buttons["Entrar com sua conta"].tap()
        
        let digiteSeuEMailTextField = app.textFields["Digite seu e-mail"]
        digiteSeuEMailTextField.tap()
        
        digiteSeuEMailTextField.typeText("k")
        digiteSeuEMailTextField.typeText("e")
        digiteSeuEMailTextField.typeText("k")
        digiteSeuEMailTextField.typeText("e")
        digiteSeuEMailTextField.typeText("@")
        digiteSeuEMailTextField.typeText("g")
        digiteSeuEMailTextField.typeText("m")
        digiteSeuEMailTextField.typeText("a")
        digiteSeuEMailTextField.typeText("i")
        digiteSeuEMailTextField.typeText("l")
        digiteSeuEMailTextField.typeText(".")
        digiteSeuEMailTextField.typeText("c")
        digiteSeuEMailTextField.typeText("o")
        digiteSeuEMailTextField.typeText("m")
        
        
        let digiteSuaSenhaSecureTextField = app.secureTextFields["Digite sua senha"]
        digiteSuaSenhaSecureTextField.tap()
        digiteSuaSenhaSecureTextField.typeText("q")
        digiteSuaSenhaSecureTextField.typeText("w")
        digiteSuaSenhaSecureTextField.typeText("e")
        digiteSuaSenhaSecureTextField.typeText("r")
        digiteSuaSenhaSecureTextField.typeText("t")
        digiteSuaSenhaSecureTextField.typeText("y")
        app.buttons["Fazer login"].tap()
        app.tabBars.buttons["Minha Conta"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.tap()
        tablesQuery.staticTexts["Adicionar novo endereço"].tap()
        
        app.buttons["Buscar pelo GPS"].tap()
        
        let nMeroTextField = app.textFields["Número"]
        nMeroTextField.tap()
        nMeroTextField.typeText("7")
        nMeroTextField.typeText("5")
        nMeroTextField.typeText("9")

        let dUmNomeAoEndereOExMinhaCasaTextField = app.textFields["Dê um nome ao endereço (Ex: \"minha casa\")"]
        dUmNomeAoEndereOExMinhaCasaTextField.tap()
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("M")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("i")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("n")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("h")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("a")
        
        dUmNomeAoEndereOExMinhaCasaTextField.typeText(" ")

        dUmNomeAoEndereOExMinhaCasaTextField.typeText("C")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("a")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("s")
        dUmNomeAoEndereOExMinhaCasaTextField.typeText("a")

        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        
        XCUIApplication().buttons["Cadastrar Endereço"].tap()
        
        let minhaCasaStaticText = app.tables.staticTexts["Minha Casa"]
        minhaCasaStaticText.swipeLeft()
        
        app.tables.children(matching: .cell).element(boundBy: 3).children(matching: .textField).element.tap()
    }
    
    func testLogin(){
        let app = XCUIApplication()
        app.tabBars.buttons["Minha Conta"].tap()
        app.buttons["Entrar com sua conta"].tap()
        
        let digiteSeuEMailTextField = app.textFields["Digite seu e-mail"]
        digiteSeuEMailTextField.tap()
    
        digiteSeuEMailTextField.typeText("a")
        digiteSeuEMailTextField.typeText("n")
        digiteSeuEMailTextField.typeText("d")
        digiteSeuEMailTextField.typeText("e")
        digiteSeuEMailTextField.typeText("r")
        digiteSeuEMailTextField.typeText("s")
        digiteSeuEMailTextField.typeText("o")
        digiteSeuEMailTextField.typeText("n")
        digiteSeuEMailTextField.typeText("@")
        digiteSeuEMailTextField.typeText("g")
        digiteSeuEMailTextField.typeText("m")
        digiteSeuEMailTextField.typeText("a")
        digiteSeuEMailTextField.typeText("i")
        digiteSeuEMailTextField.typeText("l")
        digiteSeuEMailTextField.typeText(".")
        digiteSeuEMailTextField.typeText("c")
        digiteSeuEMailTextField.typeText("o")
        digiteSeuEMailTextField.typeText("m")
        

        let digiteSuaSenhaSecureTextField = app.secureTextFields["Digite sua senha"]
        digiteSuaSenhaSecureTextField.tap()
        digiteSuaSenhaSecureTextField.typeText("q")
        digiteSuaSenhaSecureTextField.typeText("w")
        digiteSuaSenhaSecureTextField.typeText("e")
        digiteSuaSenhaSecureTextField.typeText("r")
        digiteSuaSenhaSecureTextField.typeText("t")
        digiteSuaSenhaSecureTextField.typeText("y")
        app.buttons["Fazer login"].tap()
        app.tabBars.buttons["Minha Conta"].tap()
    }
    
    func testFinishTransaction(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        tablesQuery.cells.containing(.staticText, identifier:"20.0%").buttons["Adicionar produto ao carrinho"].tap()
        app.buttons["Ver seu carrinho"].tap()
        tablesQuery.buttons["Finalizar compra para esta Pet Shop"].tap()
        
        tablesQuery.staticTexts["Escolha a forma de pagamento"].swipeUp()
        
        tablesQuery.cells.containing(.staticText, identifier:"Código: PJDnZQj9mm").buttons["Ver detalhes do pedido"].tap()
        
        tablesQuery.buttons["Fazer pagamento e finalizar compra"].tap()
        app.alerts["Pedido realizado com sucesso"].buttons["Ir para Meus Pedidos"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Código: PJDnZQj9mm").buttons["Ver detalhes do pedido"].tap()
        tablesQuery.staticTexts["Coleira Italiana para cachorros de pequeno porte com 20% de desconto!"].tap()
        
    }
    
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
