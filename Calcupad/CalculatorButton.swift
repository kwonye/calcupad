//
//  CalculatorButton.swift
//  Calcupad
//
//  Created by Will Kwon on 8/10/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

@IBDesignable class CalculatorButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setCornerAndBorderOfButton()
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerAndBorderOfButton()
    }
    
    func toggleHighlighted(_ isHighlighted: Bool) {
        if isHighlighted {
            setTitleColor(UIColor.orange, for: .normal)
            backgroundColor = UIColor.white
        } else {
            setTitleColor(UIColor.white, for: .normal)
            backgroundColor = UIColor.orange
        }
    }
    
    func setCornerAndBorderOfButton() {
        layer.borderWidth = 5.0
        layer.cornerRadius = bounds.size.height / 2
    }
    
    func isEqualButton() -> Bool {
        return titleLabel?.text == "="
    }
}
