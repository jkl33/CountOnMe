//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by admin on 20/09/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcUITests: XCTestCase {
    var calculator: Calculation!
    var mockPresenter: MockPresenter!

    override func setUp() {
        super.setUp()
        calculator = Calculation()
        mockPresenter = MockPresenter()
        calculator.delegate = mockPresenter
    }

    // Testing the four types of operation
    func testAddition() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "+")
        calculator.addNumber(number: "1")
        calculator.calculate()
        XCTAssertEqual("1 + 1 = 2.0", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    func testSubstraction() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "-")
        calculator.addNumber(number: "1")
        calculator.calculate()
        XCTAssertEqual("1 - 1 = 0.0", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    func testMultiplication() {
        calculator.addNumber(number: "2")
        calculator.addOperator(operatorToAdd: "×")
        calculator.addNumber(number: "2")
        calculator.calculate()
        XCTAssertEqual("2 × 2 = 4.0", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    func testDivision() {
        calculator.addNumber(number: "2")
        calculator.addOperator(operatorToAdd: "÷")
        calculator.addNumber(number: "2")
        calculator.calculate()
        XCTAssertEqual("2 ÷ 2 = 1.0", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    // Testing the priority of operation
    func testShouldPerformCalculationInOrderPriority() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "+")
        calculator.addNumber(number: "2")
        calculator.addOperator(operatorToAdd: "×")
        calculator.addNumber(number: "3")
        calculator.addOperator(operatorToAdd: "÷")
        calculator.addNumber(number: "4")
        calculator.addOperator(operatorToAdd: "-")
        calculator.addNumber(number: "5")
        calculator.calculate()
        XCTAssertEqual("1 + 2 × 3 ÷ 4 - 5 = -2.5", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    // Testing the error handling
    func testExpressionHaveEnoughElement() {
        calculator.addOperator(operatorToAdd: "+")
        calculator.addNumber(number: "1")
        calculator.calculate()
        XCTAssertEqual(mockPresenter.raisedErrorTitle, "Erreur")
        XCTAssertEqual(mockPresenter.raisedErrorMessage, "Démarrez un nouveau calcul !")
        XCTAssertEqual("", mockPresenter.presentedCalculation)

    }

    func testShouldPreventIncorrectExpressionAndWipeContent() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "+")
        XCTAssertEqual("1 + ", mockPresenter.presentedCalculation)
        calculator.calculate()
        XCTAssertEqual(mockPresenter.raisedErrorTitle, "Erreur")
        XCTAssertEqual(mockPresenter.raisedErrorMessage, "Entrez une expression correcte !")
        XCTAssertEqual("", mockPresenter.presentedCalculation)
    }

    func testShouldPreventDivideByZero() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "÷")
        calculator.addNumber(number: "0")
        calculator.calculate()
        XCTAssertEqual(mockPresenter.raisedErrorTitle, "Erreur")
        XCTAssertEqual(mockPresenter.raisedErrorMessage, "Impossible de diviser par 0")
        XCTAssertEqual("1 ÷ ", mockPresenter.presentedCalculation)

    }

    func testShouldIgnoreMultiplesOperators() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "+")
        calculator.addOperator(operatorToAdd: "+")
        XCTAssertEqual(mockPresenter.raisedErrorTitle, "Erreur")
        XCTAssertEqual(mockPresenter.raisedErrorMessage, "Un operateur est déja mis !")
        XCTAssertEqual("1 + ", mockPresenter.presentedCalculation)
    }

    func testShouldIgnoreMultipleCalculateCall() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "+")
        calculator.addNumber(number: "1")
        calculator.calculate()
        calculator.calculate()
        XCTAssertEqual("1 + 1 = 2.0", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    func testShouldWipeContentWhenAllClearIsPressed() {
        calculator.addNumber(number: "1")
        calculator.addOperator(operatorToAdd: "+")
        calculator.addNumber(number: "1")
        calculator.calculate()
        calculator.allClear()
        XCTAssertEqual("", mockPresenter.presentedCalculation)
        XCTAssertNil(mockPresenter.raisedErrorTitle)
    }

    func testShouldPreventInputingNumberTooBig() {
        calculator.addNumber(number: "1")
        calculator.addNumber(number: "2")
        calculator.addNumber(number: "3")
        calculator.addNumber(number: "4")
        calculator.addNumber(number: "5")
        calculator.addNumber(number: "6")
        calculator.addNumber(number: "7")
        calculator.addNumber(number: "8")
        calculator.addNumber(number: "9")
        calculator.addNumber(number: "1")
        XCTAssertEqual("123456789", mockPresenter.presentedCalculation)
        XCTAssertEqual(mockPresenter.raisedErrorTitle, "Erreur")
        XCTAssertEqual(mockPresenter.raisedErrorMessage, "Nombre trop grand !")
    }
}
