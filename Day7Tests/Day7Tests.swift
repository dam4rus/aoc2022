//
//  Day7Tests.swift
//  Day7Tests
//
//  Created by Robert Kalmar on 2022. 12. 07..
//

import XCTest
@testable import Day7

class Day7Tests: XCTestCase {

    let input = [
        "$ cd /",
        "$ ls",
        "dir a",
        "14848514 b.txt",
        "8504156 c.dat",
        "dir d",
        "$ cd a",
        "$ ls",
        "dir e",
        "29116 f",
        "2557 g",
        "62596 h.lst",
        "$ cd e",
        "$ ls",
        "584 i",
        "$ cd ..",
        "$ cd ..",
        "$ cd d",
        "$ ls",
        "4060174 j",
        "8033020 d.log",
        "5626152 d.ext",
        "7214296 k",
    ]

    func testPart1() {
        let fileSystem = FileSystem()
        for line in input {
            fileSystem.processLine(line)
        }

        XCTAssertEqual(fileSystem.dirSizes["/a/e"]!, 584)
        XCTAssertEqual(fileSystem.dirSizes["/a"]!, 94853)
        XCTAssertEqual(fileSystem.dirSizes["/d"]!, 24933642)
        XCTAssertEqual(fileSystem.dirSizes["/"]!, 48381165)
        XCTAssertEqual(fileSystem.sumDirectorySizes(withAtMostSize: 100000), 95437)
    }
    
    func testPart2() {
        let fileSystem = FileSystem()
        for line in input {
            fileSystem.processLine(line)
        }
        
        let requiredBytesForCleanup = fileSystem.requiredBytesForCleanup(targetFreeSpace: 30000000)
        XCTAssertEqual(requiredBytesForCleanup, 8381165)
        
        let smallestDirectoryToDelete = fileSystem.dirSizes.values.filter { $0 > requiredBytesForCleanup }.sorted().min()
        XCTAssertEqual(smallestDirectoryToDelete, 24933642)
    }
}
