//
//  ViewController.swift
//  Calcupad
//
//  Created by Will Kwon on 7/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var divideButton: CalculatorButton!
    @IBOutlet weak var multiplyButton: CalculatorButton!
    @IBOutlet weak var minusButton: CalculatorButton!
    @IBOutlet weak var plusButton: CalculatorButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let calculator: Calculator
    let calculationEntityName = "Calculation"
    let equationAttributeName = "equation"
    let cellIdentifier = "Cell"
    let zero = "0"
    let period = "."
    var results = [NSManagedObject]()
    var operationButtons: [CalculatorButton]?
    
    required init?(coder aDecoder: NSCoder) {
        calculator = Calculator()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: calculationEntityName)

        do {
            let resultsRequest = try managedContext.fetch(fetchRequest)
            results = resultsRequest
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        operationButtons = [divideButton, multiplyButton, minusButton, plusButton];
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        let result = results[results.count - 1 - (indexPath as NSIndexPath).row]
        
        cell!.backgroundColor = UIColor.darkText
        cell!.textLabel!.textColor = UIColor.white
        cell!.textLabel!.text = result.value(forKey: equationAttributeName) as? String
        
        return cell!
    }
    
    @IBAction func onNumberTapped(_ sender: CalculatorButton) {
        let inputText = sender.titleLabel!.text!
        let currentText = resultLabel.text!
        
        if currentText == zero || calculator.currentValue == nil || calculator.solution != nil {
            resultLabel.text = inputText
        } else {
            resultLabel.text = currentText.appending(inputText)
        }
        
        calculator.currentValue = Double(resultLabel!.text!)
    }
    
    @IBAction func onPeriodTapped(_ sender: CalculatorButton) {
        guard let currentText = resultLabel.text , !currentText.contains(period) else {
            return
        }
        
        if calculator.currentValue == nil {
            resultLabel.text = zero + period
        } else {
            resultLabel.text?.append(period)
        }
        
        calculator.currentValue = Double(resultLabel!.text!)
    }
    
    @IBAction func onBackspaceTapped(_ sender: CalculatorButton) {
        let currentText = resultLabel.text!
        
        if currentText.characters.count == 1 {
            if currentText != zero {
                resultLabel.text = zero
            }
        } else {
            resultLabel.text = currentText.substring(to: currentText.characters.index(before: currentText.endIndex))
        }
        
        calculator.currentValue = Double(resultLabel!.text!)
    }
    
    @IBAction func onNegativeTapped(_ sender: CalculatorButton) {
        guard var currentText = resultLabel.text , currentText != zero else {
            return
        }
        
        if currentText.contains(calculator.minus) {
            currentText.remove(at: currentText.startIndex)
            resultLabel.text = currentText
        } else {
            resultLabel.text = calculator.minus + currentText
        }
        
        calculator.currentValue = Double(resultLabel!.text!)
    }
    
    @IBAction func onOperationTapped(_ sender: CalculatorButton) {
        if calculator.solution != nil {
            calculator.previousValue = calculator.solution
        } else {
            calculator.previousValue = calculator.currentValue
        }
        calculator.currentValue = nil
        calculator.currentOperator = sender.titleLabel!.text!
        highlightOperationButton()
    }
    
    @IBAction func onClearTapped(_ sender: CalculatorButton) {
        resultLabel.text = zero
        calculator.currentValue = nil
    }
    
    @IBAction func onAllClearTapped(_ sender: CalculatorButton) {
        calculator.currentOperator = nil
        onClearTapped(sender)
    }
    
    @IBAction func onEqualsTapped(_ sender: CalculatorButton) {
        guard let solution = calculator.solveEquation() else {
            return
        }
        
        resultLabel.text = readableString(solution)
        
        if resultLabel.text == NSLocalizedString("Number too large", comment: "Number being too large") {
            calculator.previousValue = nil
        } else {
            saveToCoreData()
            calculator.previousValue = solution
        }
        
        clearOperationButtonHighlight()
    }
    
    @IBAction func onClearButtonTapped(_ sender: UIBarButtonItem) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: calculationEntityName)
        let fetchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            try appDelegate.managedObjectContext.execute(fetchDeleteRequest)
            results.removeAll()
        } catch let error as NSError {
            print("Couldn't save object because of error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveToCoreData() {
        let equation = "\(readableString(calculator.previousValue)) \(calculator.currentOperator!) \(readableString(calculator.currentValue)) = \(readableString(calculator.solution))"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: calculationEntityName, in: managedContext)
        
        let result = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        result.setValue(equation, forKey: equationAttributeName)
        
        do {
            try managedContext.save()
            results.append(result)
        } catch let error as NSError {
            print("Couldn't save object because of error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func clearOperationButtonHighlight() {
        for button in operationButtons! {
            button.toggleHighlighted(false)
        }
    }
    
    func highlightOperationButton() {
        for button in operationButtons! {
            button.toggleHighlighted(button.titleLabel!.text == calculator.currentOperator)
        }
    }
    
    func readableString(_ value: Double?) -> String {
        guard let currentValue = value else {
            return NSLocalizedString("Ran into an error", comment: "Ran into an error")
        }
        if currentValue > Double(Int.max) {
            return NSLocalizedString("Number too large", comment: "Number being too large")
        }
        
        if value!.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(currentValue))
        } else {
            return String(currentValue)
        }
    }
}

