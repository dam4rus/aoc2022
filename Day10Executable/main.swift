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

let device2 = try! Device(instructions: input.map { try Instruction(fromLine: $0) })
(0..<240).forEach { _ in
    let _ = device2.executeCycle()
    device2.draw()
}
print(device2.printCrt())
