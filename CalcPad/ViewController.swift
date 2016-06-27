//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
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
        if currentText == "0" && sender.titleLabel!.text! != "." {
            currentText = ""
        }
        
        resultLabel.text = currentText + sender.titleLabel!.text!
    }
}
