//
//  day1.swift
//  day1
//
//  Created by Robert Kalmar on 2022. 12. 01..
//

import Foundation

func calculateCalories<S: StringProtocol>(_ input: [S]) -> [Int] {
    input.split(separator: "").map { $0.reduce(0, { $0 + Int($1)! }) }
}

public func part1<S: StringProtocol>(_ input: [S]) -> Int {
    calculateCalories(input).max()!
}

public func part2<S: StringProtocol>(_ input: [S]) -> Int {
    calculateCalories(input).sorted().reversed()[0...2].reduce(0, { $0 + $1 })
}
