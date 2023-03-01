//
//  Calculation.swift
//  CountOnMe
//
//  Created by admin on 28/05/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit
protocol CalculationProtocol: AnyObject {
    func didRaiseError(title: String, message: String)
}

protocol DisplayProtocol: AnyObject {
    func updateDisplayedCalculation(displayedCalculation: String)
}
typealias CommonProtocol = CalculationProtocol & DisplayProtocol
class Calculation {
    weak var delegate: CommonProtocol?

    var calculationText = ""
    var elements: [String] {
        return calculationText.split(separator: " ").map { "\($0)" }
    }

    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }

    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "×" && elements.last != "÷"
    }

    var expressionHaveResult: Bool {
        return calculationText.firstIndex(of: "=") != nil
    }

    func addNumber(number: String) {
        if expressionHaveResult {
            calculationText = ""
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
        }
        calculationText.append(number)
        delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
    }

    func addOperator(operatorToAdd: String) {

        // The user can iterate on his previous operation by adding an operator after the result of the previous operation
        if expressionHaveResult {
            calculationText.removeSubrange(calculationText.startIndex...calculationText.firstIndex(of: "=")!)
        }
        if canAddOperator {
            calculationText.append(" \(operatorToAdd) ")
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
        } else {
            delegate?.didRaiseError(title: "Error", message: "Un operateur est déja mis !")
        }
    }

    func equal() {
        guard expressionIsCorrect else {
            delegate?.didRaiseError(title: "Error", message: "Entrez une expression correcte !")
            return
        }
        guard expressionHaveEnoughElement else {
            delegate?.didRaiseError(title: "Error", message: "Démarrez un nouveau calcul !")
            return
        }

        // Create local copy of operations
        var operation = elements

        // Iterate over operations while an operand still here
        while operation.count > 1 {
            let index: Int
            let prioritySign = operation.firstIndex(where: { $0 == "×" || $0 == "÷" })
            if prioritySign != nil {
                index = prioritySign!
            } else {
                index = 1
            }
            let left = Double(operation[index - 1])!
            let operand = operation[index]
            let right = Double(operation[index + 1])!
            let result: Double

            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": guard right != 0 else {
                delegate?.didRaiseError(title: "Error", message: "Can't divide by 0")
                return
            }
                result = left / right
            default: fatalError("Unknown operator !")
            }

            operation.insert("\(result)", at: index + 2)
            operation.removeSubrange(index - 1 ... index + 1)
        }
        calculationText.append(" = \(operation[0])")
        delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
    }
}
