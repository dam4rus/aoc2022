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

let part1result = try Part(input.map { Rucksack(content: $0) }).priority()
print("Part 1 priority: \(part1result)")
let part2result = try Part(ElfGroups(input: input)).priority()
print("Part 2 priority: \(part2result)")
