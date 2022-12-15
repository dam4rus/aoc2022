//
//  Day11Tests.swift
//  Day11Tests
//
//  Created by Robert Kalmar on 2022. 12. 14..
//

import XCTest
@testable import Day11



class Day11Tests: XCTestCase {

    let input = """
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""
    
    func testPart1() {
        let lines = input.split(separator: "\n")
        let monkeys = try! Monkeys(fromLines: lines)
        XCTAssertEqual(monkeys.monkeyBusinessAfter(rounds: 20, withWorryOperator: .divide), 10605)
    }
    
    func testPart2() {
        let lines = input.split(separator: "\n")
        let monkeys = try! Monkeys(fromLines: lines)
        XCTAssertEqual(Monkeys(from: monkeys).inspectionsAfter(rounds: 1, withWorryOperator: .remainder), [2, 4, 3, 6])
        XCTAssertEqual(Monkeys(from: monkeys).inspectionsAfter(rounds: 20, withWorryOperator: .remainder), [99, 97, 8, 103])
        XCTAssertEqual(Monkeys(from: monkeys).inspectionsAfter(rounds: 10000, withWorryOperator: .remainder), [52166, 47830, 1938, 52013])
        XCTAssertEqual(monkeys.monkeyBusinessAfter(rounds: 10000, withWorryOperator: .remainder), 2713310158)
    }
}
