//
//  main.swift
//  Day4Executable
//
//  Created by Robert Kalmar on 2022. 12. 04..
//

import Foundation
import Day4

let input = try String(contentsOfFile: "day4input.txt", encoding: .utf8)
    .split(separator: "\n")

let sectionAssignemts = input.map { SectionAssigments(fromLine: $0) }
let part1result = sectionAssignemts.lazy.filter { $0.hasFullyContainingAssigments() }.count
print("Part 1 fully containing assigments count: \(part1result)")
let part2result = sectionAssignemts.lazy.filter { $0.hasOverlappingAssigments() }.count
print("Part 2 overlapping assigments count: \(part2result)")
