//
//  MoonData.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/13/25.
//
import Foundation
import SunKit

struct MoonData: Codable {
    let rise: Date
    let set: Date
    let angle: Double
    let phase: LunarPhase
    let illumination: Double
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = ISO8601DateFormatter()
        
        try container.encode(dateFormatter.string(from: rise), forKey: .rise)
        try container.encode(dateFormatter.string(from: set), forKey: .set)
        try container.encode(angle, forKey: .angle)
        try container.encode(phase, forKey: .phase)
        try container.encode(illumination, forKey: .illumination)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = ISO8601DateFormatter()
        
        let riseString = try container.decode(String.self, forKey: .rise)
        let setString = try container.decode(String.self, forKey: .set)
        
        guard let riseDate = dateFormatter.date(from: riseString),
              let setDate = dateFormatter.date(from: setString) else {
            throw DecodingError.dataCorruptedError(forKey: .rise, in: container, debugDescription: "Invalid date format")
        }
        
        self.rise = riseDate
        self.set = setDate
        self.angle = try container.decode(Double.self, forKey: .angle)
        self.phase = try container.decode(LunarPhase.self, forKey: .phase)
        self.illumination = try container.decode(Double.self, forKey: .illumination)
    }
    
    private enum CodingKeys: String, CodingKey {
        case rise, set, angle, phase, illumination
    }
}
