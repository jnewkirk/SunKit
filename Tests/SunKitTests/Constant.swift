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
    
    static let alienThrone = CLLocationCoordinate2D(latitude: 36.148817, longitude: -107.980578)
    static let cupertino = CLLocationCoordinate2D(latitude: 37.322998, longitude: -122.032181)
    static let longyearbyen = CLLocationCoordinate2D(latitude: 78.22, longitude: 15.63)  // Imprecision here because we use data from https://www.timeanddate.com/sun/norway/longyearbyen?month=4&year=2025
    static let anchorage = CLLocationCoordinate2D(latitude: 61.218056, longitude: -149.900284)
    static let puyallup = CLLocationCoordinate2D(latitude: 47.099, longitude: -122.256)
    
    static let utcTimezone = TimeZone(identifier: "UTC")!
    static let pacificTimeZone = TimeZone(identifier: "America/Los_Angeles")!
    static let longyearbyenTimeZone = TimeZone(identifier: "Arctic/Longyearbyen")!
    static let mountainTimeZone = TimeZone(identifier: "America/Denver")!
    static let alaskaTimeZone = TimeZone(identifier: "America/Anchorage")
}
