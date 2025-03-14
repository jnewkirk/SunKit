//
//  Constant.swift
//  SunKitTests
//
//
//  Copyright © 2025 James Newkirk, Brad Wilson. All rights reserved.
//

import Foundation
import CoreLocation

struct Constant {
    static let testSolarDataFile = "testSolarData"
    static let testLunarDataFile = "testLunarData"
    static let waypointsDataFile = "waypoints"
    
    static var cupertino: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 37.322998, longitude: -122.032181)
    }
    static var puyallup: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: 47.185379, longitude: -122.292900)
    }
    
    public static let utcTimezone = TimeZone(identifier: "UTC")!
}
