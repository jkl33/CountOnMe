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
    let calculator = Calculation()

    override func viewDidLoad() {
        super.viewDidLoad()
        calculator.delegate = self
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculator.addNumber(number: numberText)
    }

    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        if let myOperatorToAdd = sender.titleLabel?.text {
            calculator.addOperator(operatorToAdd: myOperatorToAdd)
        }
    }

    @IBAction func tappedAllClearButton(_ sender: UIButton) {
        calculator.allClear()
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculator.calculate()
    }
}

// Delegate to handle the displaying of error message in the console and the displaying of the operation on textView
extension ViewController: CalculationProtocol {
    func didRaiseError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)    }

    func updateDisplayedCalculation(displayedCalculation: String) {
        textView.text = displayedCalculation
    }
}
