//
//  Day12Tests.swift
//  Day12Tests
//
//  Created by Robert Kalmar on 2022. 12. 15..
//

import XCTest
@testable import Day12

class Day12Tests: XCTestCase {
    
    let input = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""
    
    func testPart1() {
        let grid = Grid(fromLines: input.split(separator: "\n"))
        XCTAssertEqual(grid.calculateDistanceToEnd(), 31)
    }
    
    func testPart2() {
        let grid = Grid(fromLines: input.split(separator: "\n"))
        XCTAssertEqual(grid.calculateDistanceToEndFromAnyLowestElevation(), 29)
    }
}
