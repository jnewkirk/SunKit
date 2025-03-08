//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation

public struct LunarData: Codable, Sendable {
    internal init(rise: Date?, set: Date?, angle: Double, illumination: Double, phase: LunarPhase, nextEvents: [LunarEvent]) {
        self.rise = rise
        self.set = set
        self.angle = angle
        self.illumination = illumination
        self.phase = phase
        self.nextEvents = nextEvents
    }
    
    public let rise: Date?
    public let set: Date?
    public let angle: Double
    public let illumination: Double
    public let phase: LunarPhase
    public let nextEvents: [LunarEvent]
}
