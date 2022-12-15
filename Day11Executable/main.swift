//
//  main.swift
//  Day11Executable
//
//  Created by Robert Kalmar on 2022. 12. 15..
//

import Foundation
import Day11

let lines = try String(contentsOfFile: "day11input.txt", encoding: .utf8)
    .split(separator: "\n")
let monkeys = try! Monkeys(fromLines: lines)
print("Monkey business after 20 rounds: \(Monkeys(from: monkeys).monkeyBusinessAfter(rounds: 20, withWorryOperator: .divide))")
print("Monkey business after 10000 round: \(monkeys.monkeyBusinessAfter(rounds: 10000, withWorryOperator: .remainder))")
