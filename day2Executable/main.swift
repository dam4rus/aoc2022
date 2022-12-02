//
//  main.swift
//  day2Executable
//
//  Created by Robert Kalmar on 2022. 12. 02..
//

import Foundation
import day2

let input = try String(contentsOfFile: "day2input.txt", encoding: .utf8)
    .split(separator: "\n")

print("Score of part 1: \(Part1.calculateScore(input))")
print("Score of part 2: \(Part2.calculateScore(input))")
