//
//  main.swift
//  Day8Executable
//
//  Created by Robert Kalmar on 2022. 12. 08..
//

import Foundation
import Day8

let input = try String(contentsOfFile: "day8input.txt", encoding: .utf8)
    .split(separator: "\n")

let grid = TreeGrid(fromLines: input)
print("Visible tree count: \(grid.visibleTreeCount())")
print("Highest scenic score: \(grid.highestScenicScore())")
