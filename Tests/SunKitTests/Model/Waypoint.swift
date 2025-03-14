//
//  Waypoint.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import Foundation
import CoreLocation

struct Waypoint: Codable, Sendable {
    let name: String
    let latitude: Double
    let longitude: Double
    let tzIdentifier: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var timeZone: TimeZone {
        guard let tzIdentifier, let tz = TimeZone(identifier: tzIdentifier) else {
            debugPrint("Waypoint: \(name) - Invalid/missing timezone, defaulting to UTC")
            return Constant.utcTimezone
        }
        return tz
    }
}

extension Waypoint {
    static func load() -> [Waypoint] {
        do {
            let url = Bundle.module.url(forResource: Constant.waypointsDataFile, withExtension: "json")
            guard let url else {
                debugPrint("url=nil for \(Constant.waypointsDataFile).json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let waypoints = try decoder.decode([Waypoint].self, from: data)
            return waypoints
        } catch {
            debugPrint("Cant load \(Constant.waypointsDataFile).json: \(error)")
            return []
        }
    }
}
