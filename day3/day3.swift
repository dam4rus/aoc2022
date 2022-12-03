//
//  day3.swift
//  day3
//
//  Created by Robert Kalmar on 2022. 12. 03..
//

import Foundation

public struct Input<S: StringProtocol> {
    let lines: [S]
    
    public init(_ inputLines: [S]) {
        lines = inputLines
    }
    
//    public func elfGroups() -> ElfGroupIterator<S> {
//        ElfGroupIterator(input: lines)
//    }
}

public struct Item {
    let character: Character
    
    public init(character: Character) {
        self.character = character
    }
    
    public func priority() -> UInt {
        UInt(character.isLowercase
             ? (character.asciiValue! - Character("a").asciiValue!) + 1
             : (character.asciiValue! - Character("A").asciiValue!) + 27
        )
    }
}

public struct Rucksack<S: StringProtocol> {
    let content: S
    
    public init(content: S) {
        self.content = content
    }
    
    public func priority() -> UInt {
        let midIndex = content.index(content.startIndex, offsetBy: content.count / 2)
        let (firstCompartment, secondCompartment) = (
            content[content.startIndex ..< midIndex],
            content[midIndex ..< content.endIndex]
        )
        let commonItems = Set(firstCompartment).intersection(secondCompartment)
        return commonItems.reduce(UInt(0), { $0 + Item(character: $1).priority() })
    }
}

public struct ElfGroup<S: StringProtocol> {
    let rucksacks: ArraySlice<S>

    
    public func priority() throws -> UInt {
        let commonCharacters = rucksacks.dropFirst()
            .map { Set($0) }
            .reduce(Set(rucksacks.first!)) {
                $0.intersection($1)
            }
        if commonCharacters.count != 1 {
            throw ElfGroupError.invalidCommonItemCount(count: commonCharacters.count)
        }
        return Item(character: commonCharacters.first!).priority()
    }
}

public struct ElfGroups<S: StringProtocol>: Sequence, IteratorProtocol {
    public typealias Element = ElfGroup<S>
    
    var inputSlice: ArraySlice<S>
    
    public init(input: [S]) {
        inputSlice = ArraySlice(input)
    }
    
    mutating public func next() -> Element? {
        if inputSlice.isEmpty {
            return nil
        }
        let newStartIndex = inputSlice.index(inputSlice.startIndex, offsetBy: 3)
        let group = ElfGroup(rucksacks: inputSlice[inputSlice.startIndex ..< newStartIndex])
        inputSlice = inputSlice[newStartIndex ..< inputSlice.endIndex]
        return group
    }
}

public enum ElfGroupError: Error {
    case invalidGroupCount
    case invalidCommonItemCount(count: Int)
}
