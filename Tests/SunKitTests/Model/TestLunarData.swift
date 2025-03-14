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

struct TestLunarData: Codable {
    internal init(name: String, date: Date, latitude: Double, longitude: Double, tzIdentifier: String, lunarData: LunarData) {
        self.name = name
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.tzIdentifier = tzIdentifier
        self.lunarData = lunarData
    }
    
    let name: String
    let date: Date
    let latitude: Double
    let longitude: Double
    let tzIdentifier: String
    let lunarData: LunarData
    
    var timeZone: TimeZone {
        guard let timeZone = TimeZone(identifier: tzIdentifier) else {
            debugPrint("Invalid timezone \(tzIdentifier), defaulting to UTC")
            return Constant.utcTimezone
        }
        return timeZone
    }
}

extension TestLunarData {
    var coordinate: CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            Issue.record("Test Location has invalid coordinates: \(coordinate)")
            fatalError("Test Location has invalid coordinates: \(coordinate)")
        }
        
        return coordinate
    }
    
    static func load() -> [TestLunarData] {
        do {
            let url = Bundle.module.url(forResource: Constant.testLunarDataFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for moonData.json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let moonInfo = try decoder.decode([TestLunarData].self, from: data)
            return moonInfo
        } catch {
            Issue.record(error)
            return []
        }
    }
    
    static func save(_ lunarData: [TestLunarData]) {
        let currentPath = FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: currentPath).appendingPathComponent(Constant.testLunarDataFile + ".json")

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            try encoder.encode(lunarData).write(to: url)
        } catch {
            Issue.record(error)
        }
    }}
