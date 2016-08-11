//
//  ViewController.swift
//  Calcupad
//
//  Created by Will Kwon on 7/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var divideButton: CalculatorButton!
    @IBOutlet weak var multiplyButton: CalculatorButton!
    @IBOutlet weak var minusButton: CalculatorButton!
    @IBOutlet weak var plusButton: CalculatorButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let calculationEntityName = "Calculation"
    let equationAttributeName = "equation"
    let cellIdentifier = "Cell"
    let zero = "0"
    let period = "."
    let plus = "+"
    let minus = "−"
    let multiply = "×"
    let divide = "÷"
    var results = [NSManagedObject]()
    var previousValue: Double?
    var currentValue: Double?
    var currentOperator: String?
    var operationButtons: [CalculatorButton]?
    
    required init?(coder aDecoder: NSCoder) {
        previousValue = nil
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: calculationEntityName)
        
        do {
            let resultsRequest =
                try managedContext.executeFetchRequest(fetchRequest)
            results = resultsRequest as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operationButtons = [divideButton, multiplyButton, minusButton, plusButton];
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        let result = results[results.count - 1 - indexPath.row]
        
        cell!.textLabel!.text = result.valueForKey(equationAttributeName) as? String
        
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
        let currentText = resultLabel.text!
        
        if currentText.characters.count == 1 {
            if currentText != zero {
                resultLabel.text = zero
            }
        } else {
            resultLabel.text = currentText.substringToIndex(currentText.endIndex.predecessor())
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
        if previousValue != nil {
            previousValue = Double(resultLabel.text!)!
            onEqualsTapped()
        }
        currentOperator = sender.titleLabel!.text!
        highlightOperationButton()
        previousValue = Double(resultLabel.text!)!
        currentValue = nil
    }
    
    @IBAction func onClearTapped() {
        resultLabel.text = zero
        currentValue = nil
    }
    
    @IBAction func onAllClearTapped() {
        onClearTapped()
        previousValue = nil
        currentOperator = nil
        highlightOperationButton()
    }
    
    @IBAction func onEqualsTapped() {
        guard let solution = solveEquation() else {
            return
        }
        
        resultLabel.text = readableString(solution)
        
        if resultLabel.text == NSLocalizedString("Number too large", comment: "Number being too large") {
            previousValue = nil
        } else {
            saveToCoreData()
            previousValue = solution
        }
        
        currentValue = nil
        currentOperator = nil
        highlightOperationButton()
    }
    
    func saveToCoreData() {
        let equation = "\(readableString(previousValue)) \(currentOperator!) \(readableString(currentValue)) = \(resultLabel.text!)"
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName(calculationEntityName, inManagedObjectContext: managedContext)
        
        let result = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        result.setValue(equation, forKey: equationAttributeName)
        
        do {
            try managedContext.save()
            results.append(result)
        } catch let error as NSError {
            print("Couldn't save object because of error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func highlightOperationButton() {
        for button in operationButtons! {
            button.toggleHighlighted(button.titleLabel!.text == currentOperator)
        }
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
        
        guard let firstValue = previousValue else {
            return nil
        }
        
        switch solutionOperator {
        case plus:
            return firstValue + secondValue
        case minus:
            return firstValue - secondValue
        case multiply:
            return firstValue * secondValue
        case divide:
            return firstValue / secondValue
        default:
            return nil
        }
    }
}

