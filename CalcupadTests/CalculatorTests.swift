//
//  CalculatorTests.swift
//  Calcupad
//
//  Created by Will Kwon on 9/1/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import XCTest
@testable import Calcupad

class CalculatorTests: XCTestCase {
    var testCalculator: Calculator?
    
    override func setUp() {
        super.setUp()
        testCalculator = Calculator()
    }
    
    override func tearDown() {
        testCalculator = nil
        super.tearDown()
    }
    
    func testSolveEquationNilFirstValueReturnsNil() {
        XCTAssertNil(testCalculator?.solveEquation(nil, secondValue: 1, currentOperator: "+"))
    }
}
