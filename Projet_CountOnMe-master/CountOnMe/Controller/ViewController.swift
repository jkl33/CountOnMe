//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }

    // Instantiating Calculation class
    let calc = Calculation()

    override func viewDidLoad() {
        super.viewDidLoad()
        calc.delegate = self
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calc.addNumber(number: numberText)
    }

    @IBAction func tappedOperatorButton (_ sender: UIButton) {
        calc.addOperator(operatorToAdd: sender.titleLabel!.text!)
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calc.equal()
    }
}

// Delegate to handle the displaying of error message in the console
extension ViewController: CalculationProtocol {
    func didRaiseError(title: String, message: String) {
        print(message)
    }
}

// Delegate to handle the displaying of the operation on textView
extension ViewController: DisplayProtocol {
    func updateDisplayedCalculation(displayedCalculation: String) {
        textView.text = displayedCalculation
    }
}
