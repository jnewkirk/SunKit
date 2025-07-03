//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation

public struct LunarData: Codable, Sendable {
    public let rise: Date?
    public let set: Date?
    public let angle: Double
    public let illumination: Double
    public let phase: LunarPhase
    public let nextEvents: [LunarEvent]
}
