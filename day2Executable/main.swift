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

print("Score of part 1: \(part1(input))")
print("Score of part 2: \(part2(input))")
