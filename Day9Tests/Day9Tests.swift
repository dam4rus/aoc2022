//
//  Day9Tests.swift
//  Day9Tests
//
//  Created by Robert Kalmar on 2022. 12. 09..
//

import XCTest
@testable import Day9

class Day9Tests: XCTestCase {
    
    let input1 = [
        "R 4",
        "U 4",
        "L 3",
        "D 1",
        "R 4",
        "D 1",
        "L 5",
        "R 2",
    ]
    
    let input2 = [
        "R 5",
        "U 8",
        "L 8",
        "D 3",
        "R 17",
        "D 10",
        "L 25",
        "U 20",
    ]

    func testPart1() {
        let rope = Rope(knotCount: 2)
        try! input1.forEach(rope.step)
        XCTAssertEqual(rope.tailVisitCount, 13)
    }
    
    func testPart2() {
        let rope = Rope(knotCount: 10)
        try! input2.forEach(rope.step)
        XCTAssertEqual(rope.tailVisitCount, 36)
    }
}
