//
//  day2.swift
//  day2
//
//  Created by Robert Kalmar on 2022. 12. 02..
//

import Foundation

enum RoundResult: Int {
    case loss = 0
    case draw = 3
    case win = 6
    
    init<S: StringProtocol>(fromString: S) throws {
        switch fromString {
        case "X":
            self = RoundResult.loss
        case "Y":
            self = RoundResult.draw
        case "Z":
            self = RoundResult.win
        case let resultStr:
            throw RoundParseError.invalidExpectedResult(resultStr: String(resultStr))
        }
    }
    
    init(playerShape: Shape, opponentShape: Shape) {
        if playerShape == opponentShape {
            self = RoundResult.draw
        } else if playerShape == Shape(winsAgainst: opponentShape) {
            self = RoundResult.win
        } else {
            self = RoundResult.loss
        }
    }
}

enum Shape: Int {
    case rock = 1
    case paper = 2
    case scissors = 3
    
    init<S: StringProtocol>(fromString: S) throws {
        switch fromString {
        case "A", "X":
            self = Shape.rock
        case "B", "Y":
            self = Shape.paper
        case "C", "Z":
            self = Shape.scissors
        case let shapeStr:
            throw RoundParseError.invalidShape(shapeStr: String(shapeStr))
        }
    }
    
    init(winsAgainst: Shape) {
        switch winsAgainst {
        case .rock:
            self = Shape.paper
        case .paper:
            self = Shape.scissors
        case .scissors:
            self = Shape.rock
        }
    }
    
    init(losesAgainst: Shape) {
        switch losesAgainst {
        case .rock:
            self = Shape.scissors
        case .paper:
            self = Shape.rock
        case .scissors:
            self = Shape.paper
        }
    }
}

enum RoundParseError: Error {
    case invalidShape(shapeStr: String)
    case invalidExpectedResult(resultStr: String)
}

public protocol RoundProtocol {
    init<S: StringProtocol>(line: S) throws
    func score() -> Int
}

public protocol PartProtocol {
    associatedtype Round: RoundProtocol
}

public extension PartProtocol {
    static func calculateScore<S: StringProtocol>(_ input: [S]) -> Int {
        try! input.map { try Round(line: $0) }.reduce(0, { $0 + $1.score() })
    }
}

public struct Part1: PartProtocol {
    public struct Round: RoundProtocol {
        let opponentShape: Shape
        let playerShape: Shape
        
        public init<S: StringProtocol>(line: S) throws {
            let shapes = line.split(separator: " ")
            opponentShape = try Shape(fromString: shapes[0])
            playerShape = try Shape(fromString: shapes[1])
        }
        
        public func score() -> Int {
            return self.playerShape.rawValue + RoundResult(playerShape: playerShape, opponentShape: opponentShape).rawValue
        }
    }
}

public struct Part2: PartProtocol {
    public struct Round: RoundProtocol {
        let opponentShape: Shape
        let expectedResult: RoundResult
        
        public init<S: StringProtocol>(line: S) throws {
            let shapeAndResult = line.split(separator: " ", maxSplits: 1)
            self.opponentShape = try Shape(fromString: shapeAndResult[0])
            self.expectedResult = try RoundResult(fromString: shapeAndResult[1])
        }
        
        public func score() -> Int {
            let playerShape: Shape
            switch expectedResult {
            case .loss:
                playerShape = Shape(losesAgainst: opponentShape)
            case .draw:
                playerShape = opponentShape
            case .win:
                playerShape = Shape(winsAgainst: opponentShape)
            }
            return playerShape.rawValue + expectedResult.rawValue
        }
    }
}
