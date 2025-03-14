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
@testable import SunKit

final class TestSolarData: Codable, Sendable {
    internal init(waypoint: Waypoint, date: Date, solarData: SolarData) {
        self.waypoint = waypoint
        self.date = date
        self.solarData = solarData
    }

    let waypoint: Waypoint
    let date: Date
    let solarData: SolarData
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
