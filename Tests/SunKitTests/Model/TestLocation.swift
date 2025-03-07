//
//  City.swift
//  SunKitTests
//
// 
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Testing
import Foundation
import CoreLocation
import WeatherKit
@testable import SunKit

final class TestLocation: Identifiable, Codable, Sendable {
    internal init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, date: Date, sunData: TestSunData, timeZone: String) async {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.sunData = sunData
        self.tzIdentifier = timeZone
    }
    
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let date: Date
    let sunData: TestSunData
    let tzIdentifier: String
    
    var timeZone: TimeZone? {
        guard let timeZone = TimeZone(identifier: tzIdentifier) else {
            print ("unknown time zone ID \(tzIdentifier)")
            return nil
        }
        return timeZone
    }
}

extension TestLocation {
    var coordinate: CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            Issue.record("Test Location has invalid coordinates: \(coordinate)")
            fatalError("Test Location has invalid coordinates: \(coordinate)")
        }
        
        return coordinate
    }
}

extension TestLocation {
    static func load() -> [TestLocation] {
        do {
            let url = Bundle.module.url(forResource: Constant.testLocationFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for testLocations.json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let testLocations = try decoder.decode([TestLocation].self, from: data)
            return testLocations
        } catch {
            Issue.record(error)
            return []
        }
    }
    
    static func save(_ testLocations: [TestLocation]) {
        do {
            let url = Bundle.module.url(forResource: Constant.testLocationFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for testLocations.json")
                return
            }
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            
            try encoder.encode(testLocations).write(to: url)
        } catch {
            Issue.record(error)
        }
    }
}
