//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import Foundation
import SwiftAA

public enum LunarPhase: String, CaseIterable, Sendable, Codable {
    case new = "New Moon"
    case waningCrescent = "Waning Crescent"
    case thirdQuarter = "Third Quarter"
    case waningGibbous = "Waning Gibbous"
    case full = "Full Moon"
    case waxingGibbous = "Waxing Gibbous"
    case firstQuarter = "First Quarter"
    case waxingCrescent = "Waxing Crescent"
}
