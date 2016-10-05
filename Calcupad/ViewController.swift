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
    var previousValue: Double?
    var currentValue: Double?
    var currentOperator: String?
    var operationButtons: [CalculatorButton]?
    
    required init?(coder aDecoder: NSCoder) {
        previousValue = nil
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
        
        cell!.textLabel!.text = result.value(forKey: equationAttributeName) as? String
        
        return cell!
    }
    
    @IBAction func onNumberTapped(_ sender: CalculatorButton) {
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
        guard let currentText = resultLabel.text , !currentText.contains(period) else {
            return
        }
        
        if currentValue == nil {
            resultLabel.text = zero + period
        } else {
            resultLabel.text?.append(period)
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
            resultLabel.text = currentText.substring(to: currentText.characters.index(before: currentText.endIndex))
        }
    }
    
    @IBAction func onNegativeTapped() {
        guard var currentText = resultLabel.text , currentText != zero else {
            return
        }
        
        if currentText.contains(calculator.minus) {
            currentText.remove(at: currentText.startIndex)
            resultLabel.text = currentText
        } else {
            resultLabel.text = calculator.minus + currentText
        }
    }
    
    @IBAction func onOperationTapped(_ sender: CalculatorButton) {
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
        guard let solution = calculator.solveEquation(previousValue, secondValue: currentValue, currentOperator: currentOperator) else {
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
    
    func highlightOperationButton() {
        for button in operationButtons! {
            button.toggleHighlighted(button.titleLabel!.text == currentOperator)
        }
    }
    
    func readableString(_ value: Double?) -> String {
        if value > Double(Int.max) {
            return NSLocalizedString("Number too large", comment: "Number being too large")
        }
        
        if value!.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value!))
        } else {
            return String(value!)
        }
    }
}

