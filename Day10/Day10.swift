//
//  Day10.swift
//  Day10
//
//  Created by Robert Kalmar on 2022. 12. 13..
//

import Foundation

public enum Instruction {
    case noop
    case addx(Int)
    
    public init<S: StringProtocol>(fromLine line: S) throws {
        if line == "noop" {
            self = .noop
        } else if line.starts(with: "addx") {
            guard let addedValueRange = line.range(of: #"-?\d+"#, options: .regularExpression),
                  let addedValue = Int(line[addedValueRange])
            else {
                throw InstructionError.invalidInstruction(line: line)
            }
            self = .addx(addedValue)
        } else {
            throw InstructionError.invalidInstruction(line: line)
        }
    }
    
    public func cycleCount() -> Int {
        switch self {
        case .noop:
            return 1
        case .addx(_):
            return 2
        }
    }
}

public class Device {
    var cycle = 0
    var x = 1
    var instructions: IndexingIterator<[Instruction]>
    var currentInstruction: Instruction
    var instructionEndCycle: Int
    
    public init(instructions: [Instruction]) {
        self.instructions = instructions.makeIterator()
        currentInstruction = self.instructions.next()!
        instructionEndCycle = cycle + currentInstruction.cycleCount()
    }
    
    public func executeCycle() -> Int {
        if cycle == instructionEndCycle {
            if case let .addx(addedValue) = currentInstruction {
                x += addedValue
            }
            
            currentInstruction = instructions.next()!
            instructionEndCycle = cycle + currentInstruction.cycleCount()
        }
        
        cycle += 1
        return cycle
    }
    
    public func sumSignals(interestingCycles: [Int]) -> Int {
        (0..<interestingCycles.last!)
            .reduce(0) { (sum, _) in
                let cycle = executeCycle()
                if interestingCycles.contains(cycle) {
                    print("Value at \(cycle): \(signalStrength)")
                    print("Sum at \(cycle): \(sum + signalStrength)")
                    return sum + signalStrength
                    
                }
                return sum
            }
    }
        
    public var signalStrength: Int {
        get { cycle * x }
    }
}

public enum InstructionError<S: StringProtocol>: Error {
    case invalidInstruction(line: S)
}
