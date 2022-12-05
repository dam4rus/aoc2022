//
//  Day5.swift
//  Day5
//
//  Created by Robert Kalmar on 2022. 12. 05..
//

import Foundation

public enum Crane {
    case crateMover9000
    case crateMover9001
    
    public func executeInstruction(cargo: Cargo, instruction: Instruction) {
        switch self {
        case .crateMover9000:
            for _ in 0 ..< instruction.count {
                cargo.stacks[instruction.to - 1].append(cargo.stacks[instruction.from - 1].popLast()!)
            }
        case .crateMover9001:
            let moveBounds = (cargo.stacks[instruction.from - 1].count - instruction.count)...
            let moved = cargo.stacks[instruction.from - 1][moveBounds]
            cargo.stacks[instruction.to - 1].append(contentsOf: moved)
            cargo.stacks[instruction.from - 1].removeSubrange(moveBounds)
        }
    }
}

public class Cargo {
    var stacks: Array<Array<Character>>
    
    public init<S>(fromInput: S) where S : Collection, S.Element : StringProtocol {
        let stackCount = (fromInput.map{ $0.count }.max()! / 4) + 1
        stacks = Array(repeating: Array<Character>(), count: stackCount)
        for line in fromInput.reversed().dropFirst() {
            let stackCountInLine = (line.count / 4) + 1
            for i in 0 ..< stackCountInLine {
                let index = line.index(after: line.index(line.startIndex, offsetBy: (i * 4)))
                let cargoCharacter = line[index]
                if cargoCharacter != " " {
                    stacks[i].append(cargoCharacter)
                }
            }
        }
    }
    
    public func topCrates() -> String {
        String(stacks.compactMap { $0.last! })
    }
}

public struct Instruction {
    let count: Int
    let from: Int
    let to: Int
    
    public init<S: StringProtocol>(fromLine line: S) {
        let countCaptureRange = line.range(
            of: #"(\d+)"#,
            options: .regularExpression,
            range: line.startIndex..<line.endIndex)!
        let fromCaptureRange = line.range(
            of: #"(\d+)"#,
            options: .regularExpression,
            range: line.index(after: countCaptureRange.upperBound)..<line.endIndex)!
        let toCaptureRange = line.range(
            of: #"(\d+)"#,
            options: .regularExpression,
            range: line.index(after: fromCaptureRange.upperBound)..<line.endIndex)!
        
        count = Int(line[countCaptureRange])!
        from = Int(line[fromCaptureRange])!
        to = Int(line[toCaptureRange])!
    }
}
