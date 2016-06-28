//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let zero = "0"
    let period = "."
    let plus = "+"
    let minus = "−"
    let multiply = "×"
    let divide = "÷"
    
    var previousValue: Double
    var currentValue: Double?
    var currentOperator: String?
    @IBOutlet weak var resultLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        previousValue = 0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func onNumberTapped(_ sender: CalculatorButton) {
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
        guard let currentText = resultLabel.text where !currentText.contains(period) else {
            return
        }
        
        if currentValue == nil {
            resultLabel.text = zero + period
        } else {
            resultLabel.text?.append(period)
        }
        currentValue = Double(currentText)
    }
    
    @IBAction func onBackspaceTapped(_ sender: CalculatorButton) {
        var currentText = resultLabel.text!
        
        if currentText.characters.count == 1 {
            if currentText != zero {
                resultLabel.text = zero
            }
        } else {
            currentText.remove(at: currentText.index(before: currentText.endIndex))
            resultLabel.text = currentText
        }
    }
    
    @IBAction func onNegativeTapped() {
        guard var currentText = resultLabel.text where currentText != zero else {
            return
        }
        
        if currentText.contains(minus) {
            currentText.remove(at: currentText.startIndex)
            resultLabel.text = currentText
        } else {
            resultLabel.text = minus + currentText
        }
    }
    
    @IBAction func onOperationTapped(_ sender: CalculatorButton) {
        currentOperator = sender.titleLabel!.text!
        previousValue = Double(resultLabel.text!)!
        currentValue = nil
        sender.isHighlighted = true
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
        
        if solution.truncatingRemainder(dividingBy: 1) == 0 {
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
