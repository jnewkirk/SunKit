//
//  MoonData.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/13/25.
//
import Foundation
import SunKit

struct MoonData: Codable {
    let rise: Date?
    let set: Date?
    let angle: Double
    let phase: LunarPhase
    let illumination: Double

    internal init(rise: Date?, set: Date?, angle: Double, phase: LunarPhase, illumination: Double) {
        self.rise = rise
        self.set = set
        self.angle = angle
        self.phase = phase
        self.illumination = illumination
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = ISO8601DateFormatter()

        try container.encodeIfPresent(rise.map { dateFormatter.string(from: $0) }, forKey: .rise)
        try container.encodeIfPresent(set.map { dateFormatter.string(from: $0) }, forKey: .set)
        try container.encode(angle, forKey: .angle)
        try container.encode(phase, forKey: .phase)
        try container.encode(illumination, forKey: .illumination)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = ISO8601DateFormatter()

        if let riseString = try container.decodeIfPresent(String.self, forKey: .rise) {
            self.rise = dateFormatter.date(from: riseString)
        } else {
            self.rise = nil
        }

        if let setString = try container.decodeIfPresent(String.self, forKey: .set) {
            self.set = dateFormatter.date(from: setString)
        } else {
            self.set = nil
        }

        self.angle = try container.decode(Double.self, forKey: .angle)
        self.phase = try container.decode(LunarPhase.self, forKey: .phase)
        self.illumination = try container.decode(Double.self, forKey: .illumination)
    }

    private enum CodingKeys: String, CodingKey {
        case rise, set, angle, phase, illumination
    }
}
