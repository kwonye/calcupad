//
//  CPButtonCollectionViewCell.swift
//  CalcPad
//
//  Created by Will Kwon on 4/20/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class CPButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        button.setTitleColor(UIColor.purpleColor(), forState: UIControlState.Normal)
    }
}
