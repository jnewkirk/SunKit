import Testing
import Foundation
import CoreLocation
@testable import SunKit

final class TestSolunarData: Codable, Sendable {
    internal init(locationDescriptor: LocationDescriptor, date: Date, events: [SolunarEvent]) {
        self.locationDescriptor = locationDescriptor
        self.date = date
        self.events = events
    }

    let locationDescriptor: LocationDescriptor
    let date: Date
    let events: [SolunarEvent]
}

extension TestSolunarData {
    static func load() -> [TestSolunarData] {
        do {
            let url = Bundle.module.url(forResource: Constant.testSolunarDataFile, withExtension: "json")
            guard let url else {
                Issue.record("url is nil for testLocations.json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let testLocations = try decoder.decode([TestSolunarData].self, from: data)
            return testLocations
        } catch {
            Issue.record(error)
            return []
        }
    }
    
    static func save(_ testLocations: [TestSolunarData]) {
        let currentPath = FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: currentPath).appendingPathComponent(Constant.testSolunarDataFile + ".json")

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
