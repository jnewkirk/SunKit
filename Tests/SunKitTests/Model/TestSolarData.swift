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

final class TestSolarData: Identifiable, Codable, Sendable {
    internal init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, date: Date, solarData: SolarData, tzIdentifier: String) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.solarData = solarData
        self.tzIdentifier = tzIdentifier
    }
    
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let date: Date
    let solarData: SolarData
    let tzIdentifier: String
    
    var timeZone: TimeZone {
        guard let timeZone = TimeZone(identifier: tzIdentifier) else {
            debugPrint("Invalid timezone \(tzIdentifier), defaulting to UTC")
            return Constant.utcTimezone
        }
        return timeZone
    }
}

extension TestSolarData {
    var coordinate: CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            Issue.record("Test Location has invalid coordinates: \(coordinate)")
            fatalError("Test Location has invalid coordinates: \(coordinate)")
        }
        
        return coordinate
    }
}

extension TestSolarData {
    static func load() -> [TestSolarData] {
        do {
            let url = Bundle.module.url(forResource: Constant.testSolarDataFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for testLocations.json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let testLocations = try decoder.decode([TestSolarData].self, from: data)
            return testLocations
        } catch {
            Issue.record(error)
            return []
        }
    }
    
    static func save(_ testLocations: [TestSolarData]) {
        let currentPath = FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: currentPath).appendingPathComponent(Constant.testSolarDataFile + ".json")

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            try encoder.encode(testLocations).write(to: url)
        } catch {
            Issue.record(error)
        }
    }
}
