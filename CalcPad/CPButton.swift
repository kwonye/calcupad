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
        case clear
        case period
        case number
        case `operator`
        case equals
        case modifier
    }
    
    var text: String = ""
    var type: CPButtonType = .number
    
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
            type = .number
        } else if text == equals {
            type = .equals
        } else if text == period {
            type = .period
        } else if modifiers.contains(text) {
            type = .modifier
        } else if clear.contains(text.uppercased()) {
            type = .clear
        } else if operators.contains(text) {
            type = .operator
        }
    }
}
