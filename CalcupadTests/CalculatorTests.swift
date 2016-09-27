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
        XCTAssertNil(testCalculator!.solveEquation(nil, secondValue: 1, currentOperator: "+"))
    }
    
    func testSolveEquationNilSecondValueReturnsNil() {
        XCTAssertNil(testCalculator!.solveEquation(1, secondValue: nil, currentOperator: "+"))
    }
    
    func testSolveEquationNilOperatorReturnsNil() {
        XCTAssertNil(testCalculator!.solveEquation(1, secondValue: 2, currentOperator: nil))
    }
    
    func testSolveEquationUnknownOperatorReturnsNil() {
        XCTAssertNil(testCalculator!.solveEquation(1, secondValue: 2, currentOperator: "hey"))
    }
    
    func testSolveEquationOnePlusTwoReturnsThree() {
        XCTAssertEqual(testCalculator!.solveEquation(1, secondValue: 2, currentOperator: testCalculator!.plus), 3)
    }
    
    func testSolveEquationOneMinusTwoReturnsNegativeOne() {
        XCTAssertEqual(testCalculator!.solveEquation(1, secondValue: 2, currentOperator: testCalculator!.minus), -1)
    }
}
