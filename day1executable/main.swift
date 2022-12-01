//
//  main.swift
//  day1executable
//
//  Created by Robert Kalmar on 2022. 12. 01..
//

import Foundation
import day1

let input = try String(contentsOfFile: "day1input.txt", encoding: .utf8)
    .split(separator: "\n", omittingEmptySubsequences: false)
    .map { String($0) }

print("Part 1 result: \(part1(input))")
print("Part 2 result: \(part2(input))")
