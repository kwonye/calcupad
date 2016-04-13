//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var extraButtonsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleExtraButtonsView(self.view.frame.size)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        toggleExtraButtonsView(size)
    }
    
    func toggleExtraButtonsView(size: CGSize) {
        extraButtonsView.hidden = size.width > size.height
    }
}
