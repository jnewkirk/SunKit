//
//  City.swift
//  SunKitTests
//
//  Created by James Newkirk on January, 23. 2025.
//  Copyright © 2025 James Newkirk. All rights reserved.
//

import Testing
import Foundation
import CoreLocation
import WeatherKit
@testable import SunKit

final class TestLocation: Identifiable, Codable, Sendable {
    internal init(id: UUID = UUID(), name: String, longitude: Double, latitude: Double, date: Date, sunModel: Sun) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.date = date
        self.sunModel = sunModel
    }
    
    let id: UUID
    let name: String
    let longitude: Double
    let latitude: Double
    let date: Date
    let sunModel: Sun
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
