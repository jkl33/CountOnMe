//
//  MockTest.swift
//  CountOnMe
//
//  Created by admin2 on 17/03/2023.
//  Copyright © 2023 Vincent Saluzzo. All rights reserved.
//

@testable import CountOnMe

class MockPresenter: CalculationProtocol {
    var raisedErrorTitle: String?
    var raisedErrorMessage: String?
    var presentedCalculation: String?
    func didRaiseError(title: String, message: String) {
        raisedErrorTitle = title
        raisedErrorMessage = message
    }
    func updateDisplayedCalculation(displayedCalculation: String) {
        presentedCalculation = displayedCalculation
    }
}
