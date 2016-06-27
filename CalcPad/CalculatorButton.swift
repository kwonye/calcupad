//
//  CalculatorButton.swift
//  CalcPad
//
//  Created by Will Kwon on 6/26/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.4266758859, green: 0.4266631007, blue: 0.4266703427, alpha: 1).cgColor
    }
    
}
