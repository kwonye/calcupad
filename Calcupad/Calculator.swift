//
//  Calculator.swift
//  Calcupad
//
//  Created by Will Kwon on 9/1/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class Calculator: NSObject {
    let plus = "+"
    let minus = "−"
    let multiply = "×"
    let divide = "÷"
    var previousValue: Double?
    var currentValue: Double?
    var currentOperator: String?
    var isDecimalInput: Bool
    var timesTenthDigitMultiple: Int
    var trailingZeroes: Int
    
    override init() {
        setDefaultValues()
    }
    
    func solveEquation() -> Double? {
        return solveEquation(previousValue, secondValue: currentValue, currentOperator: currentOperator)
    }
    
    func solveEquation(_ firstValue: Double?, secondValue: Double?, currentOperator: String?) -> Double? {
        guard let firstValue = firstValue, let secondValue = secondValue, let currentOperator = currentOperator else {
            return nil
        }
        
        switch currentOperator {
        case plus:
            return firstValue + secondValue
        case minus:
            return firstValue - secondValue
        case multiply:
            return firstValue * secondValue
        case divide:
            return firstValue / secondValue
        default:
            return nil
        }
    }
    
    func isValueInt(value: Double?) -> Bool {
        guard value != nil else {
            return false
        }
        
        return floor(value!) == value
    }
    
    func inputNumber(number: Int) {
        if currentValue == nil {
            currentValue = 0.0
        }
        
        let number = Double(number)
        
        if isDecimalInput {
            timesTenthDigitMultiple += 1
            let decimalValue = number / Double(10 * timesTenthDigitMultiple)
            currentValue = currentValue! + decimalValue
        } else {
            currentValue = currentValue! * 10 + number
        }
    }
    
    func delete() {
        guard currentValue != nil else {
            return
        }
        
        if isDecimalInput {
            if timesTenthDigitMultiple == 0 {
                isDecimalInput = false
            } else {
                timesTenthDigitMultiple -= 1
                if trailingZeroes > 0 {
                    trailingZeroes -= 1
                } else {
                    // remove trailing digits
                }
            }
        } else {
            let lastDigit = currentValue!.truncatingRemainder(dividingBy: 10);
            currentValue = (currentValue! - lastDigit) / 10.0
        }
        
        if currentValue == 0.0 {
            isDecimalInput = false
            timesTenthDigitMultiple = 0
            currentOperator = nil
        }
    }
    
    func print(value: Double) -> String {
        var printValue = String()
        if isDecimalInput {
            if timesTenthDigitMultiple == 0 {
                printValue = String(Int(value))
            } else {
                var zeroes = ""
                for _ in 0...trailingZeroes {
                    zeroes = zeroes + "0"
                }
                printValue = String(value) + "." + zeroes
            }
        } else {
            if currentValue!.truncatingRemainder(dividingBy: 1) == 0 {
                printValue = String(Int(value))
            } else {
                printValue = String(value)
            }
        }
        
        return printValue
    }
    
    func printableValue() -> String {
        if currentValue == nil {
            currentValue = 0.0
        }
        
        return print(value: currentValue!)
    }
    
    func clear() {
        isDecimalInput = false
        timesTenthDigitMultiple = 0
        currentOperator = nil
        currentValue = nil
    }
    
    func clearAll() {
        clear()
        previousValue = nil
    }
    
    private func setDefaultValues() {
        isDecimalInput = false
        timesTenthDigitMultiple = 0
        trailingZeroes = 0
    }
}
