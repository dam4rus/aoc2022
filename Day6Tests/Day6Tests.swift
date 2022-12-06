//
//  Day6Tests.swift
//  Day6Tests
//
//  Created by Robert Kalmar on 2022. 12. 06..
//

import XCTest
@testable import Day6

class Day6Tests: XCTestCase {

    let input = [
        "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
        "bvwbjplbgvbhsrlpgdmjqwftvncz",
        "nppdvjthqldpwncqszvftbrmjlhg",
        "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
        "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw",
    ]

    func testPart1() {
        XCTAssertEqual(markerIndex(line: input[0], marker: .startOfPacket)!, 7)
        XCTAssertEqual(markerIndex(line: input[1], marker: .startOfPacket)!, 5)
        XCTAssertEqual(markerIndex(line: input[2], marker: .startOfPacket)!, 6)
        XCTAssertEqual(markerIndex(line: input[3], marker: .startOfPacket)!, 10)
        XCTAssertEqual(markerIndex(line: input[4], marker: .startOfPacket)!, 11)
    }
    
    func testPart2() {
        XCTAssertEqual(markerIndex(line: input[0], marker: .startOfMessage)!, 19)
        XCTAssertEqual(markerIndex(line: input[1], marker: .startOfMessage)!, 23)
        XCTAssertEqual(markerIndex(line: input[2], marker: .startOfMessage)!, 23)
        XCTAssertEqual(markerIndex(line: input[3], marker: .startOfMessage)!, 29)
        XCTAssertEqual(markerIndex(line: input[4], marker: .startOfMessage)!, 26)
    }
}
