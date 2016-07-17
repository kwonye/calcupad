//
//  ViewController.swift
//  Calcpad
//
//  Created by Will Kwon on 7/17/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    let zero = "0"
    let period = "."
    let plus = "+"
    let minus = "−"
    let multiply = "×"
    let divide = "÷"
    
    var previousValue: Double
    var currentValue: Double?
    var currentOperator: String?
    
    required init?(coder aDecoder: NSCoder) {
        previousValue = 0
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBAction func onNumberTapped(sender: CalculatorButton) {
        let inputText = sender.titleLabel!.text!
        var currentText = resultLabel.text!
        
        if currentText == zero || currentValue == nil {
            currentText = inputText
        } else {
            currentText = currentText + inputText
        }
        
        currentValue = Double(currentText)
        resultLabel.text = currentText
    }

    @IBAction func onPeriodTapped() {
        guard let currentText = resultLabel.text where !currentText.containsString(period) else {
            return
        }
        
        if currentValue == nil {
            resultLabel.text = zero + period
        } else {
            resultLabel.text?.appendContentsOf(period)
        }
        currentValue = Double(currentText)
    }
    
    @IBAction func onBackspaceTapped() {
        var currentText = resultLabel.text!
        
        if currentText.characters.count == 1 {
            if currentText != zero {
                resultLabel.text = zero
            }
        } else {
            currentText.removeAtIndex(currentText.endIndex)
            resultLabel.text = currentText
        }
    }
    
    @IBAction func onNegativeTapped() {
        guard var currentText = resultLabel.text where currentText != zero else {
            return
        }
        
        if currentText.containsString(minus) {
            currentText.removeAtIndex(currentText.startIndex)
            resultLabel.text = currentText
        } else {
            resultLabel.text = minus + currentText
        }
    }
    
    @IBAction func onOperationTapped(sender: CalculatorButton) {
        currentOperator = sender.titleLabel!.text!
        previousValue = Double(resultLabel.text!)!
        currentValue = nil
    }
    
    @IBAction func onClearTapped() {
        resultLabel.text = zero
        currentValue = nil
    }
    
    @IBAction func onAllClearTapped() {
        onClearTapped()
        previousValue = 0
    }
    
    @IBAction func onEqualsTapped() {
        guard let solution = solveEquation() else {
            return
        }
        
        if solution % 1 == 0 {
            resultLabel.text = String(Int(solution))
        } else {
            resultLabel.text = String(solution)
        }
        
        previousValue = solution
        currentValue = nil
    }
    
    func solveEquation() -> Double? {
        guard let secondValue = currentValue, solutionOperator = currentOperator else {
            return nil
        }
        
        switch solutionOperator {
        case plus:
            return previousValue + secondValue
        case minus:
            return previousValue - secondValue
        case multiply:
            return previousValue * secondValue
        case divide:
            return previousValue / secondValue
        default:
            return nil
        }
    }
}

