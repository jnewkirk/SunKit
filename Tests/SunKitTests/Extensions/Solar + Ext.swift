//
//  Solar + Ext.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import Foundation
import CoreLocation
import SunKit

extension Solar {
    func testSolarData(_ date: Date, waypoint: Waypoint) -> TestSolarData {
        return TestSolarData(waypoint: waypoint,
                             date: date,
                             solarData: solarData(date, waypoint: waypoint))
    }
        
    func solarData(_ date: Date, waypoint: Waypoint) -> SolarData {
        return SolarData(sunrise: self.dawn.actual,
                         sunset: self.dusk.actual,
                         daylight: self.daylight,
                         astronomicalDawn: self.dawn.astronomical,
                         astronomicalDusk: self.dusk.astronomical,
                         civilDawn: self.dawn.civil,
                         civilDusk: self.dusk.civil,
                         nauticalDawn: self.dawn.nautical,
                         nauticalDusk: self.dusk.nautical,
                         solarNoon: self.solarNoon,
                         solarMidnight: nil,
                         solarAngle: self.angle,
                         morningBlueHour: self.dawn.blueHour,
                         morningGoldenHour: self.dawn.goldenHour,
                         eveningGoldenHour: self.dusk.goldenHour,
                         eveningBlueHour: self.dusk.blueHour)
    }
}
