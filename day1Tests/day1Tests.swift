//
//  day1Tests.swift
//  day1Tests
//
//  Created by Robert Kalmar on 2022. 12. 01..
//

import XCTest
@testable import day1

class day1Tests: XCTestCase {
    
    let testInput = [
        "1000",
        "2000",
        "3000",
        "",
        "4000",
        "",
        "5000",
        "6000",
        "",
        "7000",
        "8000",
        "9000",
        "",
        "10000",
    ]

    func testPart1() {
        XCTAssertEqual(part1(testInput), 24000)
    }

    func testPart2() {
        XCTAssertEqual(part2(testInput), 45000)
    }
}
