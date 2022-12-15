//
//  Day12.swift
//  Day12
//
//  Created by Robert Kalmar on 2022. 12. 15..
//

import Foundation

public struct Point: Equatable, Hashable {
    let x: Int
    let y: Int

    public init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

public class Node: Equatable, Hashable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.position == rhs.position
    }
    
    public let level: Character
    public let position: Point
    public var distance = Int.max
    
    public init(level: Character, position: Point) {
        self.level = level
        self.position = position
    }
    
    public init(copyFrom node: Node) {
        self.level = node.level
        self.position = node.position
        self.distance = node.distance
    }
    
    public func manhattanDistance(toNode node : Node) -> Int {
        abs(self.position.x - node.position.x) + abs(self.position.y - node.position.y)
    }
    
    public var height: UInt8 {
        get {
            characterHeight(character: level)
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(position)
    }
}

public class Grid {
    let width: Int
    let height: Int
    var nodes: [Node]
    var startNode: Node
    var visitedNodes: Set<Node>

    public init<S: StringProtocol>(fromLines lines: [S]) {
        width = lines.first!.count
        height = lines.count
        nodes = lines.enumerated()
            .flatMap { y, line in
                line.enumerated().map { x, character in Node(level: character, position: Point(x, y)) }
            }

        startNode = nodes.first { $0.level == "S" }!
        visitedNodes = Set([startNode])
    }
    
    public init(copyFrom grid: Grid) {
        self.width = grid.width
        self.height = grid.height
        self.nodes = grid.nodes.map { Node(copyFrom: $0) }
        self.startNode = self.nodes.first { $0.level == "S" }!
        self.visitedNodes = Set()
    }

    public func calculateDistanceToEnd(startingNode: Node? = nil) -> Int {
        let startFrom = startingNode ?? startNode
        startFrom.distance = 0
        var nodes = Set([startFrom])
        while !nodes.isEmpty {
            var neighbourNodes = Set<Node>()
            for node in nodes {
                let unvisitedNeighbours = getUnvisitedNeighbours(node: node)
                for neighbour in unvisitedNeighbours {
                    if node.distance + 1 < neighbour.distance {
                        neighbour.distance = node.distance + 1
                    }
                }
                neighbourNodes.formUnion(unvisitedNeighbours)
                visitedNodes.insert(node)
            }
            nodes = neighbourNodes
        }
        return distanceToEnd
    }
    
    public func calculateDistanceToEndFromAnyLowestElevation() -> Int? {
        nodes.lazy
            .filter { $0.height == characterHeight(character: "a") }
            .map { node in
                Grid(copyFrom: self).calculateDistanceToEnd(startingNode: node)
            }
            .min()
    }
    
    func getUnvisitedNeighbours(node: Node) -> Set<Node> {
        var neighbours = Set<Node>()
        if let leftNode = node.position.x > 0 ? nodes[node.position.y * width + node.position.x - 1] : nil {
            if leftNode.height <= node.height + 1 && !visitedNodes.contains(leftNode) {
                neighbours.insert(leftNode)
            }
        }
        if let topNode = node.position.y > 0 ? nodes[(node.position.y - 1) * width + node.position.x] : nil {
            if topNode.height <= node.height + 1 && !visitedNodes.contains(topNode) {
                neighbours.insert(topNode)
            }
        }
        if let rightNode = node.position.x < width - 1 ? nodes[node.position.y * width + node.position.x + 1] : nil {
            if rightNode.height <= node.height + 1 && !visitedNodes.contains(rightNode) {
                neighbours.insert(rightNode)
            }
        }
        if let bottomNode = node.position.y < height - 1 ? nodes[(node.position.y + 1) * width + node.position.x] : nil {
            if bottomNode.height <= node.height + 1 && !visitedNodes.contains(bottomNode) {
                neighbours.insert(bottomNode)
            }
        }
        return neighbours
    }
    
    public var distanceToEnd: Int {
        get {
            nodes.first { $0.level == "E" }!.distance
        }
    }
}

func characterHeight(character: Character) -> UInt8 {
    switch character {
    case "S":
        return Character("a").asciiValue!
    case "E":
        return Character("z").asciiValue!
    case let level:
        return level.asciiValue!
    }
}

