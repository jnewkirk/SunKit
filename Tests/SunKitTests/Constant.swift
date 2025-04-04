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
    
    static let cupertino = CLLocationCoordinate2D(latitude: 37.322998, longitude: -122.032181)
    static let longyearbyen = CLLocationCoordinate2D(latitude: 78.22745806736931, longitude: 15.77845128961993)
    
    static let utcTimezone = TimeZone(identifier: "UTC")!
    static let pacificTimeZone = TimeZone(identifier: "America/Los_Angeles")!
    static let longyearbyenTimeZone = TimeZone(identifier: "Arctic/Longyearbyen")!
}
