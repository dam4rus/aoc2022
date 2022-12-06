//
//  Day6.swift
//  Day6
//
//  Created by Robert Kalmar on 2022. 12. 06..
//

import Foundation

public enum Marker: Int {
    case startOfPacket = 4
    case startOfMessage = 14
}

public func markerIndex<S: StringProtocol>(line: S, marker: Marker) -> Int? {
    for i in 0..<line.count - marker.rawValue + 1 {
        let packet = line[line.index(line.startIndex, offsetBy: i)...].prefix(marker.rawValue)
        if Set(packet).count == marker.rawValue {
            return Int(packet.endIndex.utf16Offset(in: line))
        }
    }
    
    return nil
}
