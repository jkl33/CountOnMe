//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by admin on 20/09/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe
// swiftlint:disable line_length

class SimpleCalcUITests: XCTestCase {
    var calculation: Calculation!

    override func setUp() {
        super.setUp()
        calculation = Calculation()
    }

    // Testing the four types of operation
    func testGivenOperationIsOnePlusOne_WhenHittingEqualButton_ThenResultShouldBeTwo() {
        calculation.calculationText = "1 + 1"
        calculation.equal()
        XCTAssertTrue(calculation.calculationText == "1 + 1 = 2.0")
    }

    func testGivenOperationIsOneMinusOne_WhenHittingEqualButton_ThenResultShouldBeZero() {
        calculation.calculationText = "1 - 1"
        calculation.equal()
        XCTAssertTrue(calculation.calculationText == "1 - 1 = 0.0")
    }

    func testGivenOperationIsTwoTimesTwo_WhenHittingEqualButton_ThenResultShouldBeFour() {
        calculation.calculationText = "2 × 2"
        calculation.equal()
        XCTAssertTrue(calculation.calculationText == "2 × 2 = 4.0")
    }

    func testGivenOperationIsTwoDividedByTwo_WhenHittingEqualButton_ThenResultShouldBeOne() {
        calculation.calculationText = "2 ÷ 2"
        calculation.equal()
        XCTAssertTrue(calculation.calculationText == "2 ÷ 2 = 1.0")
    }

    //Testing the priority of operation
    func testGivenOperationIsOnePlusTwoTimesThreeDividedByFourMinusFive_WhenHittingEqualButton_ThenresultShouldBeMinusTwoPointFive() {
        calculation.calculationText = "1 + 2 × 3 ÷ 4 - 5"
        calculation.equal()
        XCTAssertTrue(calculation.calculationText == "1 + 2 × 3 ÷ 4 - 5 = -2.5")
    }

}
