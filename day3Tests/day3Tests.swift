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
        XCTAssertEqual(try Part(testInput.map { Rucksack(content: $0) }).priority(), 157)
    }
    
    func testPart2() {
        XCTAssertEqual(try Part(ElfGroups(input: testInput)).priority(), 70)
    }
}
