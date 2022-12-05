//
//  Day4.swift
//  Day4
//
//  Created by Robert Kalmar on 2022. 12. 04..
//

import Foundation

public struct SectionAssigments {
    let firstElf: ClosedRange<UInt>
    let secondElf: ClosedRange<UInt>
    
    public init<S: StringProtocol>(fromLine line: S) {
        let assignmentPair = line.split(separator: ",")
        let firstPair = assignmentPair[0].split(separator: "-")
        firstElf = UInt(firstPair[0])! ... UInt(firstPair[1])!
        let secondPair = assignmentPair[1].split(separator: "-")
        secondElf = UInt(secondPair[0])! ... UInt(secondPair[1])!
    }
    
    public func hasFullyContainingAssigments() -> Bool {
        let (largerRange, smallerRange) = firstElf.count >= secondElf.count
        ? (firstElf, secondElf)
        : (secondElf, firstElf)
        return smallerRange.allSatisfy { largerRange.contains($0) }
    }
    
    public func hasOverlappingAssigments() -> Bool {
        firstElf.count >= secondElf.count
        ? firstElf.overlaps(secondElf)
        : secondElf.overlaps(firstElf)
    }
}
