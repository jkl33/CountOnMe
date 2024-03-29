//
//  Calculation.swift
//  CountOnMe
//
//  Created by admin on 28/05/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.

import Foundation
import UIKit
protocol CalculationProtocol: AnyObject {
    func didRaiseError(title: String, message: String)
    func updateDisplayedCalculation(displayedCalculation: String)
}

class Calculation {
    weak var delegate: CalculationProtocol?

    private var calculationText = ""
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
        return elements.contains("=")
    }

    var numberIsNotTooBig: Bool {
        if let nbr = elements.last?.count {
            return nbr < 10
        } else {
            return false
        }
    }

    func addNumber(number: String) {
        if expressionHaveResult {
            calculationText = ""
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
        }
        calculationText.append(number)
        delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
        guard numberIsNotTooBig else {
            delegate?.didRaiseError(title: "Erreur", message: "Nombre trop grand !")
            calculationText.removeLast()
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
            return
        }
    }

    func addOperator(operatorToAdd: String) {

        // The user can iterate on his previous operation by adding an operator after the result of the previous operation
        if expressionHaveResult {
            if let myIndex = calculationText.firstIndex(of: "=") {
                calculationText.removeSubrange(calculationText.startIndex...myIndex)
            }
        }
        if canAddOperator {
            calculationText.append(" \(operatorToAdd) ")
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
        } else {
            delegate?.didRaiseError(title: "Erreur", message: "Un operateur est déja mis !")
        }
    }

    func allClear() {
        calculationText = ""
        delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
    }

    func verifyCalculation() -> Bool {
        guard expressionIsCorrect else {
            delegate?.didRaiseError(title: "Erreur", message: "Entrez une expression correcte !")
            calculationText = ""
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
            return false
        }
        guard expressionHaveEnoughElement else {
            delegate?.didRaiseError(title: "Erreur", message: "Démarrez un nouveau calcul !")
            calculationText = ""
            delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
            return false
        }
        if expressionHaveResult {
            // improvement: could raise an error to let the delegate choose either to handle it or not
            return false
        }
        return true
    }

    // swiftlint:disable:next cyclomatic_complexity
    func calculate() {
        guard verifyCalculation() else {
            return
        }
        // Create local copy of operations
        var operation = elements

        // Iterate over operations while an operand still here
        while operation.count > 1 {
            let index: Int
            if let prioritySign = operation.firstIndex(where: { $0 == "×" || $0 == "÷" }) {
                index = prioritySign
            } else {
                index = 1
            }
            guard let left = Double(operation[index - 1]) else {
                return
            }
            let operand = operation[index]
            guard let right = Double(operation[index + 1]) else {
                return
            }
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": guard right != 0 else {
                delegate?.didRaiseError(title: "Erreur", message: "Impossible de diviser par 0")
                calculationText.removeLast()
                delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
                return
            }
                result = left / right
            default:
                delegate?.didRaiseError(title: "Erreur", message: "Operateur non reconnu '\(operand)'")
                return
            }

            operation.insert("\(result)", at: index + 2)
            operation.removeSubrange(index - 1 ... index + 1)
        }
        calculationText.append(" = \(operation[0])")
        delegate?.updateDisplayedCalculation(displayedCalculation: calculationText)
    }
}
