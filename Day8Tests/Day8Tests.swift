//
//  Day8Tests.swift
//  Day8Tests
//
//  Created by Robert Kalmar on 2022. 12. 08..
//

import XCTest
@testable import Day8

class Day8Tests: XCTestCase {

    let input = [
        "30373",
        "25512",
        "65332",
        "33549",
        "35390",
    ]
    
    func testPart1() {
        let grid = TreeGrid(fromLines: input)        
        XCTAssertEqual(grid.visibleTreeCount(), 21);
    }
    
    func testPart2() {
        let grid = TreeGrid(fromLines: input)
        XCTAssertEqual(grid.highestScenicScore(), 8)
    }
}
