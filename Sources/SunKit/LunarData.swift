//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation

public struct LunarData: Codable, Sendable {
    internal init(moonRise: Date? = nil, moonSet: Date? = nil, illumination: Double, phase: LunarPhase) {
        self.moonRise = moonRise
        self.moonSet = moonSet
        self.illumination = illumination
        self.phase = phase
    }
    
    public let moonRise: Date?
    public let moonSet: Date?
    public let illumination: Double
    public let phase: LunarPhase
}
