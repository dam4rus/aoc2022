//
//  Day5Tests.swift
//  Day5Tests
//
//  Created by Robert Kalmar on 2022. 12. 05..
//

import XCTest
@testable import Day5

class Day5Tests: XCTestCase {

    let input = [
        "    [D]    ",
        "[N] [C]    ",
        "[Z] [M] [P]",
        " 1   2   3",
        "",
        "move 1 from 2 to 1",
        "move 3 from 1 to 3",
        "move 2 from 2 to 1",
        "move 1 from 1 to 2",
    ]
    
    func testPart1() {
        let splits = input.split(separator: "", maxSplits: 1)
        let cargo = Cargo(fromInput: splits[0])
        splits[1].map { Instruction(fromLine: $0) }.forEach { Crane.crateMover9000.executeInstruction(cargo: cargo, instruction: $0) }
        
        XCTAssertEqual(cargo.topCrates(), "CMZ")
    }

    func testPart2() {
        let splits = input.split(separator: "", maxSplits: 1)
        let cargo = Cargo(fromInput: splits[0])
        splits[1].map { Instruction(fromLine: $0) }.forEach { Crane.crateMover9001.executeInstruction(cargo: cargo, instruction: $0) }
        
        XCTAssertEqual(cargo.topCrates(), "MCD")
    }
}
