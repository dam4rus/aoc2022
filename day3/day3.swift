//
//  day3.swift
//  day3
//
//  Created by Robert Kalmar on 2022. 12. 03..
//

import Foundation

public struct Part<R> where R: Sequence, R.Element : PartProtocol {
    let rucksacks: R
    
    public init(_ input: R) {
        self.rucksacks = input
    }
    
    public func priority() throws -> UInt {
        try rucksacks.reduce(0, { try $0 + $1.priority() })
    }
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

public protocol PartProtocol {
    associatedtype CommonCharacterCollection: Collection where CommonCharacterCollection.Element == Character
    
    func commonCharacters() -> CommonCharacterCollection
}

public extension PartProtocol {
    func priority() throws -> UInt {
        let commonCharacters = commonCharacters()
        if commonCharacters.count != 1 {
            throw RucksackError.invalidCommonItemCount(count: commonCharacters.count)
        }
        
        return Item(character: commonCharacters.first!).priority()
    }
}

public struct Rucksack<S: StringProtocol>: PartProtocol {
    public typealias CommonCharacterCollection = Set<Character>
    
    let content: S
    
    public init(content: S) {
        self.content = content
    }
    
    public func commonCharacters() -> CommonCharacterCollection {
        let midIndex = content.index(content.startIndex, offsetBy: content.count / 2)
        let (firstCompartment, secondCompartment) = (
            Set(content[content.startIndex ..< midIndex]),
            Set(content[midIndex ..< content.endIndex])
        )
        return firstCompartment.intersection(secondCompartment)
    }
}

public struct ElfGroup<S: StringProtocol>: PartProtocol {
    public typealias CommonCharacterCollection = Set<Character>
    
    let rucksacks: ArraySlice<S>
    
    public func commonCharacters() -> CommonCharacterCollection {
        rucksacks.dropFirst()
            .map { Set($0) }
            .reduce(Set(rucksacks.first!)) {
                $0.intersection($1)
            }
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

public enum RucksackError: Error {
    case invalidCommonItemCount(count: Int)
}

public enum ElfGroupError: Error {
    case invalidGroupCount
}
