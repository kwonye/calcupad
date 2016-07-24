//
//  ViewController.swift
//  Calcpad
//
//  Created by Will Kwon on 7/17/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let zero = "0"
    let period = "."
    let plus = "+"
    let minus = "−"
    let multiply = "×"
    let divide = "÷"
    
    var results = [NSManagedObject]()
    var previousValue: Double
    var currentValue: Double?
    var currentOperator: String?
    
    required init?(coder aDecoder: NSCoder) {
        previousValue = 0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let result = results[indexPath.row]
        
        cell!.textLabel!.text = result.valueForKey("equation") as? String
        
        return cell!
    }

    @IBAction func onNumberTapped(sender: CalculatorButton) {
        let inputText = sender.titleLabel!.text!
        var currentText = resultLabel.text!
        
        if currentText == zero || currentValue == nil {
            currentText = inputText
        } else {
            currentText = currentText + inputText
        }
        
        currentValue = Double(currentText)
        resultLabel.text = currentText
    }

    @IBAction func onPeriodTapped() {
        guard let currentText = resultLabel.text where !currentText.containsString(period) else {
            return
        }
        
        if currentValue == nil {
            resultLabel.text = zero + period
        } else {
            resultLabel.text?.appendContentsOf(period)
        }
        currentValue = Double(currentText)
    }
    
    @IBAction func onBackspaceTapped() {
        var currentText = resultLabel.text!
        
        if currentText.characters.count == 1 {
            if currentText != zero {
                resultLabel.text = zero
            }
        } else {
            currentText.removeAtIndex(currentText.endIndex)
            resultLabel.text = currentText
        }
    }
    
    @IBAction func onNegativeTapped() {
        guard var currentText = resultLabel.text where currentText != zero else {
            return
        }
        
        if currentText.containsString(minus) {
            currentText.removeAtIndex(currentText.startIndex)
            resultLabel.text = currentText
        } else {
            resultLabel.text = minus + currentText
        }
    }
    
    @IBAction func onOperationTapped(sender: CalculatorButton) {
        currentOperator = sender.titleLabel!.text!
        previousValue = Double(resultLabel.text!)!
        currentValue = nil
    }
    
    @IBAction func onClearTapped() {
        resultLabel.text = zero
        currentValue = nil
    }
    
    @IBAction func onAllClearTapped() {
        onClearTapped()
        previousValue = 0
    }
    
    @IBAction func onEqualsTapped() {
        guard let solution = solveEquation() else {
            return
        }
        
        resultLabel.text = readableString(solution)
        
        if resultLabel.text == NSLocalizedString("Number too large", comment: "Number being too large") {
            previousValue = 0
            currentValue = nil
        } else {
            saveToCoreData()
        
            previousValue = solution
            currentValue = nil
        }
    }
    
    func saveToCoreData() {
        let equation = "\(readableString(previousValue)) \(currentOperator!) \(readableString(currentValue)) = \(resultLabel.text!)"
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Calculation", inManagedObjectContext: managedContext)
        
        let result = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        result.setValue(equation, forKey: "equation")
        
        do {
            try managedContext.save()
            results.append(result)
        } catch let error as NSError {
            print("Couldn't save object because of error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func readableString(value: Double?) -> String {
        if value > Double(Int.max) {
            return NSLocalizedString("Number too large", comment: "Number being too large")
        }
        
        if value! % 1 == 0 {
            return String(Int(value!))
        } else {
            return String(value!)
        }
    }

    
    func solveEquation() -> Double? {
        guard let secondValue = currentValue, solutionOperator = currentOperator else {
            return nil
        }
        
        switch solutionOperator {
        case plus:
            return previousValue + secondValue
        case minus:
            return previousValue - secondValue
        case multiply:
            return previousValue * secondValue
        case divide:
            return previousValue / secondValue
        default:
            return nil
        }
    }
}

