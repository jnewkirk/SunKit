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
    internal init(waypoint: Waypoint, date: Date, lunarData: LunarData) {
        self.waypoint = waypoint
        self.date = date
        self.lunarData = lunarData
    }
    
    let date: Date
    let waypoint: Waypoint
    let lunarData: LunarData
}

extension TestLunarData {
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
