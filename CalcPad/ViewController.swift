//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    var buttons: [Int]
    let numberOfSections = 4
    let spacingZero: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        buttons = [Int]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        buttons.append(1)
        buttons.append(2)
        buttons.append(3)
        buttons.append(4)
        buttons.append(5)
        buttons.append(6)
        buttons.append(7)
        buttons.append(8)
        buttons.append(9)
        buttons.append(0)
        buttons.append(1)
        buttons.append(2)
        buttons.append(3)
        buttons.append(4)
        buttons.append(5)
        buttons.append(6)
        buttons.append(7)
        buttons.append(8)
        buttons.append(9)
        buttons.append(0)
        
        super.viewDidLoad()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return sizeOfCell()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return spacingZero
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CPButtonCollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell!
        
        return cell
    }
    
    func sizeOfCell() -> CGSize {
        let height = buttonsCollectionView.frame.height / numberOfSections
        return CGSize(width: height, height: height)
    }
}
