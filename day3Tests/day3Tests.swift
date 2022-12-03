//
//  day3Tests.swift
//  day3Tests
//
//  Created by Robert Kalmar on 2022. 12. 03..
//

import XCTest
@testable import day3

class day3Tests: XCTestCase {

    let testInput = [
        "vJrwpWtwJgWrhcsFMMfFFhFp",
        "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
        "PmmdzqPrVvPwwTWBwg",
        "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
        "ttgJtRGJQctTZtZT",
        "CrZsJsPPZsGzwwsLwLmpwMDw",
    ]

    func testPart1() {
        XCTAssertEqual(testInput.reduce(0, { $0 + Rucksack(content: $1).priority() }), 157)
    }
    
    func testPart2() {
        XCTAssertEqual(try ElfGroups(input: testInput).map { try $0.priority() }.reduce(0) { $0 + $1 }, 70);
    }
}
