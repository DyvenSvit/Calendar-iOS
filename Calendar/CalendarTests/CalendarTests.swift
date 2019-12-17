//
//  CalendarTests.swift
//  CalendarTests
//
//  Created by Developer on 2/26/19.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import XCTest
import PromiseKit
@testable import Calendar

class CalendarTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetDays() {
        var daysResponse: [Day]?
        let exp = expectation(description: "days")
        WebAPI.shared.getDayListFor(month:2, year:2019).done{
            days in
            daysResponse = days
            exp.fulfill()
        }
            .catch{
                error in
                print(error)
                exp.fulfill()
        }
        waitForExpectations(timeout: 120) { (error) in
            XCTAssertNotNil(daysResponse)
            print(daysResponse)
        }
    }
    
    func testGetText() {
        var daysResponse: [Day]?
        let exp = expectation(description: "days")
        WebAPI.shared.getDayListFor(month:2, year:2019).done{
            days in
            daysResponse = days
            exp.fulfill()
            }
            .catch{
                error in
                print(error)
                exp.fulfill()
        }
        waitForExpectations(timeout: 120) { (error) in
            XCTAssertNotNil(daysResponse)
            print(daysResponse)
        }
        if let day = daysResponse?.first {
        var textResponse: Day?
        let exp2 = expectation(description: "text")
        WebAPI.shared.getText(type: .holiday, for: day).done{
            day in
            textResponse = day
            exp2.fulfill()
            }
            .catch{
                error in
                print(error)
                exp2.fulfill()
        }
        waitForExpectations(timeout: 120) { (error) in
            XCTAssertNotNil(textResponse)
            print(textResponse)
        }
        }
    }
    
    
    func testGetTexts() {
        var daysResponse: [Day]?
        let exp = expectation(description: "days")
        WebAPI.shared.getDayListFor(month:2, year:2019).done{
            days in
            daysResponse = days
            exp.fulfill()
            }
            .catch{
                error in
                print(error)
                exp.fulfill()
        }
        waitForExpectations(timeout: 120) { (error) in
            XCTAssertNotNil(daysResponse)
            print(daysResponse)
        }
        guard let days = daysResponse else {
            XCTFail()
            return
        }
        for day in days {
            var textResponse: Day?
            let exp2 = expectation(description: "text")
            
            let promises:[Promise<Day>] = [WebAPI.shared.getText(type: .holiday, for: day),
                WebAPI.shared.getText(type: .quotes, for: day),
                WebAPI.shared.getText(type: .rule, for: day),
                WebAPI.shared.getText(type: .liturgy, for: day),
                WebAPI.shared.getText(type: .evening, for: day),
                WebAPI.shared.getText(type: .morning, for: day),
                WebAPI.shared.getText(type: .hours, for: day)]
            
            when(resolved: promises).done { (results: [Result<Day>]) in
                print(results)
                guard let result = results.last else {
                    exp2.fulfill()
                    return
                }
                
                if case let .fulfilled(day) = result {
                    textResponse = day
                }
                else {
                    textResponse = nil
                }
                exp2.fulfill()
            }
            
            waitForExpectations(timeout: 120) { (error) in
                XCTAssertNotNil(textResponse)
                print(textResponse)
            }
        }
    }

    func testPerformanceExample() {
        
        var daysResponse: [Day]?
        let exp = expectation(description: "getAllData")
        WebAPI.shared.getAllData(month: 1, year: 2019,
                                 progress: {
                                    progress in
                                    print("progress: \(progress*100) %")
                                    
        }, completion: {
            result, error in
            print(error)
            daysResponse = result
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 360) { (error) in
            XCTAssertNotNil(daysResponse)
            //print(daysResponse)
        }
    }

}
