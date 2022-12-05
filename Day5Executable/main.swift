//
//  main.swift
//  Day5Executable
//
//  Created by Robert Kalmar on 2022. 12. 05..
//

import Foundation
import Day5

let input = try String(contentsOfFile: "day5input.txt", encoding: .utf8)
    .split(separator: "\n", omittingEmptySubsequences: false)

let splits = input.split(separator: "", maxSplits: 1)
let instructions = splits[1]
    .filter{ !$0.isEmpty }
    .map { Instruction(fromLine: $0) }

func executeInstructionsOnCargo(crane: Crane) -> String {
    let cargo = Cargo(fromInput: splits[0])
    instructions.forEach { crane.executeInstruction(cargo: cargo, instruction: $0) }
    return cargo.topCrates()
}

print("Top crates with Crate Mover 9000 \(executeInstructionsOnCargo(crane: .crateMover9000))")
print("Top crates with Crate Mover 9001 \(executeInstructionsOnCargo(crane: .crateMover9001))")
