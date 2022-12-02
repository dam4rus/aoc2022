//
//  day2Tests.swift
//  day2Tests
//
//  Created by Robert Kalmar on 2022. 12. 02..
//

import XCTest
@testable import day2

class day2Tests: XCTestCase {

    let testInput = [
        "A Y",
        "B X",
        "C Z",
    ]
    
    func testPart1() {
        XCTAssertEqual(Part1.calculateScore(testInput), 15)
    }

    func testPart2() {
        XCTAssertEqual(Part2.calculateScore(testInput), 12)
    }
}
