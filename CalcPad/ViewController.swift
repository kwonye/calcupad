//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var previousValue: Double?
    var currentValue: Double?
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
        
        if currentText == "0" || (previousValue != nil && currentValue == nil) {
            currentText = inputText
        } else {
            currentText = currentText + inputText
        }
        
        currentValue = Double(currentText)
        resultLabel.text = currentText
    }
    
    @IBAction func onPeriodTapped() {
        if let currentText = resultLabel.text where !currentText.contains(".") {
            if previousValue != nil && currentValue == nil {
                resultLabel.text = "0."
            } else {
                resultLabel.text?.append(".")
            }
            currentValue = Double(currentText)
        }
    }
    
    @IBAction func onBackspaceTapped(_ sender: CalculatorButton) {
        var currentText = resultLabel.text!
        
        if currentText.characters.count == 1 {
            if currentText != "0" {
                resultLabel.text = "0"
            }
        } else {
            currentText.remove(at: currentText.index(before: currentText.endIndex))
            resultLabel.text = currentText
        }
    }
    
    @IBAction func onNegativeTapped() {
        if var currentText = resultLabel.text where currentText != "0" {
            let firstCharacter = currentText[currentText.startIndex]
            
            if firstCharacter == "-" {
                currentText.remove(at: currentText.startIndex)
                resultLabel.text = currentText
            } else {
                resultLabel.text = "-" + currentText
            }
        }
    }
    
    @IBAction func onOperationTapped(_ sender: CalculatorButton) {
        previousValue = Double(resultLabel.text!)!
        currentValue = nil
        sender.isHighlighted = true
    }
    
    @IBAction func onClearTapped() {
        resultLabel.text = "0"
        currentValue = nil
    }
    
    @IBAction func onAllClearTapped() {
        onClearTapped()
        previousValue = 0
    }
    
    @IBAction func onEqualsTapped() {
        if let firstValue = previousValue, secondValue = currentValue {
            let solution = firstValue + secondValue
            
            if solution.truncatingRemainder(dividingBy: 1) == 0 {
                resultLabel.text = String(Int(solution))
            } else {
                resultLabel.text = String(solution)
            }
            
            previousValue = solution
            currentValue = nil
        }
    }
}
