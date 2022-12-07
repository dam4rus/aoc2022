//
//  main.swift
//  Day7Executable
//
//  Created by Robert Kalmar on 2022. 12. 07..
//

import Foundation
import Day7

let input = try String(contentsOfFile: "day7input.txt", encoding: .utf8)
    .split(separator: "\n")

let fileSystem = FileSystem()
for line in input {
    fileSystem.processLine(line)
}

print("Sum of directories sizes with at most 100000 size: \(fileSystem.sumDirectorySizes(withAtMostSize: 100000))")

let requiredBytesForCleanup = fileSystem.requiredBytesForCleanup(targetFreeSpace: 30000000)
let smallestDirectoryToDelete = fileSystem.directorySizes.filter { $0 > requiredBytesForCleanup }.sorted().min()!
print("Smallest directory to delete: \(smallestDirectoryToDelete)")
