//
//  CPButton.swift
//  CalcPad
//
//  Created by Will Kwon on 4/3/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

public class CPButton: NSObject {
    let equals = "="
    let period = "."
    let operators = ["÷", "×", "+", "-"]
    let modifiers = ["⁺∕₋", "%"]
    let clear = ["C", "AC"]
    
    public enum CPButtonType {
        case Clear
        case Period
        case Number
        case Operator
        case Equals
        case Modifier
    }
    
    var text: String = ""
    var type: CPButtonType = .Number
    
    override init() {
    }
    
    init(text: String) {
        self.text = text
        super.init()
        setType()
    }
    
    convenience init(int: Int) {
        self.init(text: String(int))
    }
    
    func setType() {
        if Int(text) != nil {
            type = .Number
        } else if text == equals {
            type = .Equals
        } else if text == period {
            type = .Period
        } else if modifiers.contains(text) {
            type = .Modifier
        } else if clear.contains(text.uppercaseString) {
            type = .Clear
        } else if operators.contains(text) {
            type = .Operator
        }
    }
}
