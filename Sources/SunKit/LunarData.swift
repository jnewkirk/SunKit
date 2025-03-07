//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation

public struct LunarData: Codable, Sendable {
    internal init(rise: Date?, set: Date?, illumination: Double, phase: LunarPhase) {
        self.rise = rise
        self.set = set
        self.illumination = illumination
        self.phase = phase
    }
    
    public let rise: Date?
    public let set: Date?
    public let illumination: Double
    public let phase: LunarPhase
}
