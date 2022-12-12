//
//  Day9.swift
//  Day9
//
//  Created by Robert Kalmar on 2022. 12. 09..
//

import Foundation

public struct Point: Hashable {
    public var x = 0
    public var y = 0
    
    public init() {
        
    }
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public enum DirectionError: Error {
    case invalidDirection(character: String)
}

public enum Direction {
    case left, right, up, down
    
    public init<S: StringProtocol>(fromChar: S) throws {
        switch fromChar {
        case "L":
            self = .left
        case "R":
            self = .right
        case "U":
            self = .up
        case "D":
            self = .down
        case let char:
            throw DirectionError.invalidDirection(character: String(char))
        }
    }
    
    func moveHead(head: inout Point) {
        switch self {
        case .left:
            head.x -= 1
        case .right:
            head.x += 1
        case .up:
            head.y += 1
        case .down:
            head.y -= 1
        }
    }
}

public class Rope {
    var knots: [Point]
    var tailPositions = Set([Point()])
    
    public init(knotCount: Int) {
        self.knots = Array(repeating: Point(), count: knotCount)
    }
    
    public func step<S: StringProtocol>(fromLine line: S) throws {
        let count = Int(String(line.suffix(from: line.index(line.startIndex, offsetBy: 2))))!
        let direction = try Direction(fromChar: String(line.first!))
        for _ in 0..<count {
            direction.moveHead(head: &knots[0])
            var iterPositions = false
            for i in 1..<knots.count {
                let head = knots[i - 1]
                var tail = knots[i]
                iterPositions = adjustTail(head: head, tail: &tail)
                knots[i] = tail
            }
            
            if iterPositions {
                tailPositions.insert(knots.last!)
            }
        }
    }
    
    public var tailVisitCount: Int {
        get { tailPositions.count }
    }
    
    func adjustTail(head: Point, tail: inout Point) -> Bool {
        if abs(head.x - tail.x) > 1 {
            if tail.x < head.x {
                tail.x += 1
            } else {
                tail.x -= 1
            }
            if tail.y < head.y {
                tail.y += 1
            } else if tail.y > head.y {
                tail.y -= 1
            }
            return true
        }
        
        if abs(head.y - tail.y) > 1 {
            if tail.y < head.y {
                tail.y += 1
            } else {
                tail.y -= 1
            }
            if tail.x < head.x {
                tail.x += 1
            } else if tail.x > head.x {
                tail.x -= 1
            }
            return true
        }
        
        return false
    }
}
