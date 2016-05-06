//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    var buttons: [CPButton]
    let numberOfSections = 4
    let numberOfColumns = 5
    let spacingZero = 0
    
    required init?(coder aDecoder: NSCoder) {
        buttons = [CPButton]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        buttons.append(CPButton(int: 7))
        buttons.append(CPButton(int: 8))
        buttons.append(CPButton(int: 9))
        buttons.append(CPButton(text: "/"))
        buttons.append(CPButton(text: "AC"))
        buttons.append(CPButton(int: 4))
        buttons.append(CPButton(int: 5))
        buttons.append(CPButton(int: 6))
        buttons.append(CPButton(text: "x"))
        buttons.append(CPButton(text: "+/-"))
        buttons.append(CPButton(int: 1))
        buttons.append(CPButton(int: 2))
        buttons.append(CPButton(int: 3))
        buttons.append(CPButton(text: "-"))
        buttons.append(CPButton(text: "%"))
        buttons.append(CPButton(int: 0))
        buttons.append(CPButton(int: 0))
        buttons.append(CPButton(text: "."))
        buttons.append(CPButton(text: "+"))
        buttons.append(CPButton(text: "="))
        
        super.viewDidLoad()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return sizeOfCell()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(spacingZero)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count / numberOfSections
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CPButtonCollectionViewCell", forIndexPath: indexPath) as! CPButtonCollectionViewCell
        cell.data = buttonFrom(indexPath)
        cell.button.setTitle(cell.data.text, forState: .Normal)
        cell.button.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func buttonPressed(sender: AnyObject) {
        let button = sender as! UIButton
        let cpButton = CPButton(text: button.currentTitle!)
        if shouldAppendToResultLabel(cpButton) {
            appendText(cpButton.text)
        }
    }
    
    func sizeOfCell() -> CGSize {
        let height = buttonsCollectionView.frame.height / CGFloat(numberOfSections)
        return CGSize(width: height, height: height)
    }
    
    func buttonFrom(indexPath: NSIndexPath) -> CPButton {
        let sectionAddition = indexPath.section * numberOfColumns
        return buttons[indexPath.item + sectionAddition]
    }
    
    func shouldAppendToResultLabel(button: CPButton) -> Bool {
        let type = button.type
        return type == .Number || type == .Period
    }
    
    func appendText(text: String) {
        if resultLabel.text == "0" {
            resultLabel.text = text
        } else {
            resultLabel.text = resultLabel.text?.stringByAppendingString(text)
        }
    }
}
