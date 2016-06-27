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
        var currentText = resultLabel.text!
        if currentText == "0" || previousValue != nil {
            currentText = ""
        }
        
        resultLabel.text = currentText + sender.titleLabel!.text!
    }
    
    @IBAction func onPeriodTapped() {
        if let currentText = resultLabel.text where !currentText.contains(".") {
            resultLabel.text?.append(".")
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
    }
    
    @IBAction func onAllClearTapped() {
        onClearTapped()
        // Clear all preferences
    }
}
