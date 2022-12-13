//
//  main.swift
//  Day10Executable
//
//  Created by Robert Kalmar on 2022. 12. 13..
//

import Foundation
import Day10

let interestingCycles = [ 20, 60, 100, 140, 180, 220 ]
let input = try String(contentsOfFile: "day10input.txt", encoding: .utf8)
    .split(separator: "\n")

let device = try! Device(instructions: input.map { try Instruction(fromLine: $0) })
print("Sum of signals \(device.sumSignals(interestingCycles: interestingCycles))")
