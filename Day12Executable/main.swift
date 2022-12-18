//
//  main.swift
//  Day12Executable
//
//  Created by Robert Kalmar on 2022. 12. 16..
//

import Foundation
import Day12

let grid = Grid(fromLines: try String(contentsOfFile: "day12input.txt", encoding: .utf8)
    .split(separator: "\n"))

let distanceToEnd = Grid(copyFrom: grid).calculateDistanceToEnd()
print("Steps: \(distanceToEnd)")

let distanceToEndFromAnyLowest = grid.calculateDistanceToEndFromAnyLowestElevation()!
print("Steps from any lowest elevation: \(distanceToEndFromAnyLowest)")
