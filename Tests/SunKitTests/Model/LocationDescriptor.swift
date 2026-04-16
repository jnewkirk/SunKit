import Foundation
import CoreLocation

struct LocationDescriptor: Codable {
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

extension LocationDescriptor {
    static func load() -> [LocationDescriptor] {
        do {
            let url = Bundle.module.url(forResource: Constant.locationDescriptorsDataFile, withExtension: "json")
            guard let url else {
                debugPrint("url=nil for \(Constant.locationDescriptorsDataFile).json")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let data = try Data(contentsOf: url)
            let descriptors = try decoder.decode([LocationDescriptor].self, from: data)
            return descriptors
        } catch {
            debugPrint("Cant load \(Constant.locationDescriptorsDataFile).json: \(error)")
            return []
        }
    }
}
