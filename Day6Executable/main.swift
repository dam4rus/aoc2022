//
//  main.swift
//  Day6Executable
//
//  Created by Robert Kalmar on 2022. 12. 06..
//

import Foundation
import Day6

let input = try String(contentsOfFile: "day6input.txt", encoding: .utf8)
    .split(separator: "\n")
    .first!

print("Start of packet signal: \(markerIndex(line: input, marker: Marker.startOfPacket)!)")
print("Start of message signal: \(markerIndex(line: input, marker: Marker.startOfMessage)!)")
