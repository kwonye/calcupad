//
//  ViewController.swift
//  CalcPad
//
//  Created by Will Kwon on 3/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    var buttons: [Int]
    
    required init?(coder aDecoder: NSCoder) {
        buttons = [Int]()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        buttonsCollectionView.dataSource = self
        
        super.viewDidLoad()
        
        
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
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CPButtonCollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell!
        cell.backgroundColor = UIColor.blackColor()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = UIColor.brownColor()
        cell.selectedBackgroundView = view
        
        return cell
    }
}
