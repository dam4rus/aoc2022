//
//  Day7.swift
//  Day7
//
//  Created by Robert Kalmar on 2022. 12. 07..
//

import Foundation

public class FileSystem {
    var dirSizes = ["/" : 0]
    var dirStack = [""]
    
    public var directorySizes: Dictionary<String, Int>.Values {
        get { dirSizes.values }
    }
    
    var usedSpace: Int {
        get { dirSizes["/"]! }
    }
    
    var freeSpace: Int {
        get { 70000000 - dirSizes["/"]! }
    }
    
    public init() {
        
    }
    
    public func processLine<S: StringProtocol>(_ line: S) {
        if line.starts(with: "$ cd ") {
            let targetDirectory = line.dropFirst("$ cd ".count)
            switch targetDirectory {
            case "/":
                dirStack = Array(arrayLiteral: dirStack.first!)
            case "..":
                let _ = dirStack.popLast()
            case let dirNameSlice:
                let dirName = String(dirNameSlice)
                dirStack.append(dirName)
                let absoluteDirName = dirStack.joined(separator: "/")
                if dirSizes[absoluteDirName] == nil {
                    dirSizes[absoluteDirName] = 0
                }
                
            }
        } else if let range = line.range(of: #"\d+ "#, options: .regularExpression) {
            let fileSize = Int(String(line.prefix(range.upperBound.utf16Offset(in: line) - 1)))!
            var absoluteDirName = ""
            for directory in dirStack {
                absoluteDirName += directory
                dirSizes[absoluteDirName.isEmpty ? "/" : absoluteDirName]! += fileSize
                absoluteDirName += "/"
            }
        }
    }
    
    public func sumDirectorySizes(withAtMostSize: Int) -> Int {
        dirSizes.lazy.filter { $1 < withAtMostSize }.reduce(0) { $0 + $1.1 }
    }
    
    public func requiredBytesForCleanup(targetFreeSpace: Int) -> Int {
        targetFreeSpace - freeSpace
    }
}
