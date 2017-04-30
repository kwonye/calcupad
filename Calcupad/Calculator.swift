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
    let minus = "-"
    let multiply = "×"
    let divide = "÷"
    var previousValue: Double?
    var currentValue: Double?
    var currentOperator: String?
    var solution: Double?
    
    func solveEquation() -> Double? {
        solution = solveEquation(previousValue, secondValue: currentValue, currentOperator: currentOperator)
        
        return solution
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
}
