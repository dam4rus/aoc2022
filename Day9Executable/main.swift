//
//  main.swift
//  Day9Executable
//
//  Created by Robert Kalmar on 2022. 12. 09..
//

import Foundation
import Day9

let input = try String(contentsOfFile: "day9input.txt", encoding: .utf8)
    .split(separator: "\n")

let rope = Rope(knotCount: 2)
try! input.forEach(rope.step)
print("Tail visit count with 2 knots: \(rope.tailVisitCount)")

let rope2 = Rope(knotCount: 10)
try! input.forEach(rope2.step)
print("Tail visit count with 10 knots: \(rope2.tailVisitCount)")
