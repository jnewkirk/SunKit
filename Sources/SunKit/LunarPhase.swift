//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation

public enum LunarPhase: String, CaseIterable, Codable, Sendable {
    case new = "New"
    case waningCrescent = "Waning Crescent"
    case thirdQuarter = "Third Quarter"
    case waningGibbous = "Waning Gibbous"
    case full = "Full"
    case waxingGibbous = "Waxing Gibbous"
    case firstQuarter = "First Quarter"
    case waxingCrescent = "Waxing Crescent"
}
