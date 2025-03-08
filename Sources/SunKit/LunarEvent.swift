//
//  LunarEvent.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/7/25.
//

import Foundation

public struct LunarEvent: Codable, Sendable {
    let phase: LunarPhase
    let date: Date
}
