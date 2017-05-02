//
//  CalcupadUITests.swift
//  CalcupadUITests
//
//  Created by Will Kwon on 7/30/16.
//  Copyright © 2016 Will Kwon. All rights reserved.
//

import XCTest

class CalcupadUITests: XCTestCase {
    var resultLabelValue = ""
    var app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
        resultLabelValue = app.staticTexts.element(matching: .any, identifier: "Results").label
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddition() {
        app.buttons["3"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(resultLabelValue, "9")
    }
    
    func testMultiply() {
        app.buttons["2"].tap()
        app.buttons["×"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(resultLabelValue, "6")
    }
    
    func testSelfEquals() {
        app.buttons["2"].tap()
        app.buttons["×"].tap()
        app.buttons["="].tap()
        
        XCTAssertEqual(resultLabelValue, "4")
    }
}
