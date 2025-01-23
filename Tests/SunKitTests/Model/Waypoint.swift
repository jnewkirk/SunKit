//
//  Waypoint.swift
//  SunKitTests
//
//  Created by James Newkirk on January, 23. 2025.
//  Copyright © 2025 James Newkirk. All rights reserved.
//

import Testing
import Foundation

struct Waypoint: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

extension Waypoint {
    static func load() -> [Waypoint] {
        if let url = Bundle.module.url(forResource: Constant.waypointFile, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let waypoints = try decoder.decode([Waypoint].self, from: data)
                return waypoints
            } catch {
                Issue.record(error)
            }
        }
        return []
    }
    
    static func save(_ waypoints: [Waypoint]) {
        do {
            let url = Bundle.module.url(forResource: Constant.waypointFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for waypoints.json")
                return
            }
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            try encoder.encode(waypoints).write(to: url)
        } catch {
            Issue.record(error)
        }
    }
}

