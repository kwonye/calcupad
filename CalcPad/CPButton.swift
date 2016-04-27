//
//  CPButton.swift
//  CalcPad
//
//  Created by Will Kwon on 4/3/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class CPButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 0.25
    }
}
