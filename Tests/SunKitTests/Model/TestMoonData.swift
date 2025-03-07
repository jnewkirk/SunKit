//
//  File.swift
//  SunKit
//
//  Created by Jim Newkirk on 2/11/25.
//

import CoreLocation
import Foundation
import SunKit
import Testing

struct MoonData: Codable {
    let rise: Date
    let set: Date
    let phase: LunarPhase
    let illumination: Double
}

struct LocationMoonInfo: Codable {
    internal init(name: String, date: Date, latitude: Double, longitude: Double, tzIdentifier: String, moonData: MoonData) {
        self.name = name
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.moonData = moonData
        self.tzIdentifier = tzIdentifier
    }
    
    let name: String
    let date: Date
    let latitude: Double
    let longitude: Double
    let tzIdentifier: String
    let moonData: MoonData
    
    var timeZone: TimeZone? {
        guard let timeZone = TimeZone(identifier: tzIdentifier) else {
            print ("unknown time zone ID \(tzIdentifier)")
            return nil
        }
        return timeZone
    }
}

extension LocationMoonInfo {
    var coordinate: CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            Issue.record("Test Location has invalid coordinates: \(coordinate)")
            fatalError("Test Location has invalid coordinates: \(coordinate)")
        }
        
        return coordinate
    }
    
    static func load() -> [LocationMoonInfo] {
        do {
            let url = Bundle.module.url(forResource: Constant.testMoonFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for moonData.json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let moonInfo = try decoder.decode([LocationMoonInfo].self, from: data)
            return moonInfo
        } catch {
            Issue.record(error)
            return []
        }
    }
}
