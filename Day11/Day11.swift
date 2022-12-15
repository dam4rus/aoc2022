//
//  Day11.swift
//  Day11
//
//  Created by Robert Kalmar on 2022. 12. 14..
//

import Foundation
import Parsing

public enum OperationArgument {
    case old
    case number(UInt64)
}

public enum Operation {
    case plus
    case multiply
}

public enum WorryOperator {
    case divide
    case remainder
}

public class Monkey {
    static let LINE_COUNT_PER_MONKEY = 6;
    
    var items: [UInt64]
    let operation: (UInt64) -> UInt64
    let testDivider: Int
    let trueIndex: Int
    let falseIndex: Int
    
    public init<S>(fromLines lines: [S]) throws where S: StringProtocol, S.SubSequence == Substring {
        items = try Parse {
            Skip {
                PrefixThrough("  Starting items: ")
            }
            Many {
                UInt64.parser()
            } separator: {
                ", "
            }
        }
        .parse(lines[1])
        
        operation = try Parse {
            Skip {
                PrefixThrough("  Operation: new = old ")
            }
            OneOf {
                "+ ".map { Operation.plus }
                "* ".map { Operation.multiply }
            }
            OneOf {
                UInt64.parser().map { OperationArgument.number($0) }
                "old".map { OperationArgument.old }
            }
        }
        .map { operation, argument in
            switch operation {
            case .plus:
                switch argument {
                case .old:
                    return { old in old + old }
                case .number(let i):
                    return { old in old + i }
                }
            case .multiply:
                switch argument {
                case .old:
                    return { old in old * old }
                case .number(let i):
                    return { old in old * i }
                }
            }
        }
        .parse(lines[2])
        
        testDivider = try Parse {
            Skip {
                PrefixThrough("  Test: divisible by ")
            }
            Int.parser()
        }
        .parse(lines[3])
        
        trueIndex = try Parse {
            Skip {
                PrefixThrough("    If true: throw to monkey ")
            }
            Int.parser()
        }
        .parse(lines[4])
        
        falseIndex = try Parse {
            Skip {
                PrefixThrough("    If false: throw to monkey ")
            }
            Int.parser()
        }
        .parse(lines[5])
    }
    
    public init(from: Monkey) {
        self.items = from.items
        self.operation = from.operation
        self.testDivider = from.testDivider
        self.falseIndex = from.falseIndex
        self.trueIndex = from.trueIndex
    }
}

public class Monkeys {
    let monkeys: [Monkey]
    
    public init<S>(fromLines lines: [S]) throws where S: StringProtocol, S.SubSequence == Substring {
        monkeys = try (0..<lines.count / Monkey.LINE_COUNT_PER_MONKEY)
            .map { try Monkey(fromLines: Array(lines.dropFirst($0 * Monkey.LINE_COUNT_PER_MONKEY).prefix(Monkey.LINE_COUNT_PER_MONKEY))) }
    }
    
    public init(from: Monkeys) {
        self.monkeys = from.monkeys.map { Monkey(from: $0) }
    }
    
    public func inspectionsAfter(rounds: Int, withWorryOperator worryOperator: WorryOperator) -> [UInt64] {
        var inspectCounts = Array(repeating: UInt64(0), count: monkeys.count)
        let remainder = monkeys.map { $0.testDivider }.reduce(monkeys.first!.testDivider) { $0 * $1 }
        for _ in 0..<rounds {
            for (i, monkey) in monkeys.enumerated() {
                while !monkey.items.isEmpty {
                    let item = monkey.items.removeFirst()
                    let worryLevel: UInt64
                    switch worryOperator {
                    case .divide:
                        worryLevel = monkey.operation(item) / 3
                    case .remainder:
                        worryLevel = monkey.operation(item) % UInt64(remainder)
                    }
                    
                    let throwIndex = (worryLevel % UInt64(monkey.testDivider)) == 0 ? monkey.trueIndex : monkey.falseIndex
                    monkeys[throwIndex].items.append(worryLevel)
                    inspectCounts[i] += 1
                }
            }
        }
        
        return inspectCounts
    }
    
    public func monkeyBusinessAfter(rounds: Int, withWorryOperator worryOperator: WorryOperator) -> UInt64 {
        let sortedInspections = inspectionsAfter(rounds: rounds, withWorryOperator: worryOperator).sorted { $0 > $1 }
        return sortedInspections[0] * sortedInspections[1]
    }
}
