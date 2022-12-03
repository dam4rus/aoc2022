//
//  main.swift
//  day3Executable
//
//  Created by Robert Kalmar on 2022. 12. 03..
//

import Foundation
import day3

let input = try String(contentsOfFile: "day3input.txt", encoding: .utf8)
    .split(separator: "\n")

let part1result = try input.reduce(0, { try $0 + Rucksack(content: $1).priority() })
print("Part 1 priority: \(part1result)")
let part2result = try ElfGroups(input: input).map { try $0.priority() }.reduce(0) { $0 + $1 }
print("Part 2 priority: \(part2result)")
