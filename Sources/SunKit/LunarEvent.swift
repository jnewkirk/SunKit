//
//  LunarEvent.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/7/25.
//

import Foundation

public struct LunarEvent: Codable, Sendable {
    public let phase: LunarPhase
    public let date: Date
}
