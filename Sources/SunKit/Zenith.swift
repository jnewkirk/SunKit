//
//  Zenith.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/25/25.
//

import Foundation
import SwiftAA

enum Zenith: Double, CaseIterable, Sendable {
    case goldenHour = 84
    case official = 90.83
    case blueHour = 94
    case civil = 96
    case nautical = 102
    case astronimical = 108
    
    var degree: Degree { return Degree(90 - self.rawValue) }
}
