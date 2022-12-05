//
//  Day4Tests.swift
//  Day4Tests
//
//  Created by Robert Kalmar on 2022. 12. 04..
//

import XCTest
@testable import Day4

class Day4Tests: XCTestCase {

    let testInput = [
        "2-4,6-8",
        "2-3,4-5",
        "5-7,7-9",
        "2-8,3-7",
        "6-6,4-6",
        "2-6,4-8",
    ]
    
    func testPart1() {
        XCTAssertEqual(testInput.lazy.map { SectionAssigments(fromLine: $0) }.filter { $0.hasFullyContainingAssigments() }.count, 2)
    }

    func testPart2() {
        XCTAssertEqual(testInput.lazy.map { SectionAssigments(fromLine: $0) }.filter { $0.hasOverlappingAssigments() }.count, 4)
    }
}
