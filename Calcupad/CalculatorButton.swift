//
//  CalculatorButton.swift
//  Calcupad
//
//  Created by Will Kwon on 8/10/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
    }
    
    func toggleHighlighted(_ isHighlighted: Bool) {
        if isHighlighted {
            layer.borderWidth = 3
        } else {
            layer.borderWidth = 0.5
        }
    }
}
