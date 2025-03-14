//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation
import SwiftAA

public enum LunarPhase: String, CaseIterable, Sendable {
    case new = "New Moon"
    case waningCrescent = "Waning Crescent"
    case thirdQuarter = "Third Quarter"
    case waningGibbous = "Waning Gibbous"
    case full = "Full Moon"
    case waxingGibbous = "Waxing Gibbous"
    case firstQuarter = "First Quarter"
    case waxingCrescent = "Waxing Crescent"
    
    public static func map(from phaseAngle: Degree) -> LunarPhase {
        print("phase angle: \(phaseAngle.value)")
        switch phaseAngle {
        case 0..<90:
            return .waxingCrescent
        case 90..<180:
            return .waxingGibbous
        case 180..<270:
            return .waningGibbous
        default:
            return .waningCrescent
        }
    }
}

extension LunarPhase : Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        guard let phase = LunarPhase(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid lunar phase: \(rawValue)")
        }
        
        self = phase
    }
}
