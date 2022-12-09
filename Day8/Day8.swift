//
//  Day8.swift
//  Day8
//
//  Created by Robert Kalmar on 2022. 12. 08..
//

import Foundation

public class TreeGrid {
    let grid: [[UInt8]]
    
    public init<S: StringProtocol>(fromLines lines: [S]) {
        grid = lines.map { $0.map { UInt8(String($0))! } }
    }
    
    public func scenicScore(x: Int, y: Int) -> Int {
        let treeHeight = grid[y][x]
        if treeHeight == 0 {
            return 1
        }
        let row = grid[y]
        let leftVisible = treesVisible(in: row.prefix(x).reversed(), treeHeight: treeHeight)
        let rightVisible = treesVisible(in: row.suffix(from: x + 1), treeHeight: treeHeight)
        let topVisible = treesVisible(in: grid.prefix(y).reversed().map { $0[x] }, treeHeight: treeHeight)
        let bottomVisible = treesVisible(in: grid.suffix(from: y + 1).map { $0[x] }, treeHeight: treeHeight)
        return leftVisible * rightVisible * topVisible * bottomVisible
    }
    
    public func visibleTreeCount() -> Int {
        let edgeCount = (rowCount * 2 + columnCount * 2) - 4
        let visibleCount = (0..<rowCount)
            .dropFirst()
            .dropLast()
            .flatMap { y in (0..<columnCount).dropFirst().dropLast().map { x in (x, y) } }
            .filter { x, y in isTreeVisible(x: x, y: y) }
            .count

        return edgeCount + visibleCount
    }
    
    public func highestScenicScore() -> Int {
        (0..<rowCount)
            .dropFirst()
            .dropLast()
            .flatMap { y in (0..<columnCount).dropFirst().dropLast().map {x in (x, y) } }
            .map { x, y in scenicScore(x: x, y: y) }
            .max()!
    }
    
    func treesVisible<C>(in slice: C, treeHeight: UInt8) -> Int where C: Collection, C.Element == UInt8 {
        slice.firstIndex(where: { $0 >= treeHeight}).map { slice.distance(from: slice.startIndex, to: $0) + 1 }
        ?? slice.count
    }
    
    func isTreeVisible(x: Int, y: Int) -> Bool {
        let treeHeight = grid[y][x]
        if treeHeight == 0 {
            return false
        }
        let row = grid[y]
        if row.prefix(x).allSatisfy({ $0 < treeHeight }) || row.suffix(from: x + 1).allSatisfy({ $0 < treeHeight }) {
            return true
        }
        return grid.prefix(y).allSatisfy({ $0[x] < treeHeight}) || grid.suffix(from: y + 1).allSatisfy({ $0[x] < treeHeight})
    }
    
    var rowCount: Int {
        get { grid.count }
    }
    var columnCount: Int {
        get { grid.first!.count }
    }
}
