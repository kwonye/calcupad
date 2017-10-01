//
//  CalcupadUITests.swift
//  CalcupadUITests
//
//  Created by Will Kwon on 7/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import XCTest

class CalcupadUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddition() {
        pressButtons(buttons: [3, "+", 6, "="], expected: 9)
    }
    
    func testMultiply() {
        pressButtons(buttons: [2, "×", 3, "="], expected: 6)
    }
    
    func testSubtraction() {
        pressButtons(buttons: [1, "-", 4, "="], expected: -3)
    }
    
    func testContinuationOfEquationAfterSolution() {
        pressButtons(buttons: [2, "×", 3, "=", "×", 2, "="], expected: 12)
    }
    
    func testContinuationOfEquationAfterSolutionWithRepeatNumber() {
        pressButtons(buttons: [2, "×", 3, "=", "="], expected: 18)
    }
    
    func testSolutionMultipliesItselfAfterSolution() {
        pressButtons(buttons: [2, "×", 3, "=", "×", "="], expected: 36)
    }
    
    func testAdditionByItself() {
        pressButtons(buttons: [3, "+", "="], expected: 6)
    }
    
    func pressButtons(buttons: [Any], expected: Any) {
        for button in buttons {
            app.buttons[String(describing: button)].tap()
        }
        
        let result = app.staticTexts.element(matching: .any, identifier: "Results").label
        
        XCTAssertEqual(result, String(describing: expected))
    }
}
