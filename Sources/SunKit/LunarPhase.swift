//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation
import SwiftAA

public enum LunarPhase: String, CaseIterable, Codable, Sendable {
    case new = "New"
    case waningCrescent = "Waning Crescent"
    case thirdQuarter = "Third Quarter"
    case waningGibbous = "Waning Gibbous"
    case full = "Full"
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
