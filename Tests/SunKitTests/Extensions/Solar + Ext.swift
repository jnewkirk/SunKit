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
    func testLunarData(_ date: Date, waypoint: Waypoint) -> TestLunarData {
        return TestLunarData(name: waypoint.name,
                             date: date,
                             latitude: waypoint.latitude,
                             longitude: waypoint.longitude,
                             tzIdentifier: waypoint.timeZone.identifier,
                             lunarData: lunarData(date, waypoint: waypoint))
    }
    
    func testSolarData(_ date: Date, waypoint: Waypoint) -> TestSolarData {
        return TestSolarData(name: waypoint.name,
                             latitude: waypoint.latitude,
                             longitude: waypoint.longitude,
                             date: date,
                             solarData: solarData(date, waypoint: waypoint),
                             tzIdentifier: waypoint.timeZone.identifier)
    }
    
    func lunarData(_ date: Date, waypoint: Waypoint) -> LunarData {
        return LunarData(rise: self.lunar.rise,
                         set: self.lunar.set,
                         angle: self.lunar.angle,
                         phase: self.lunar.phase,
                         illumination: self.lunar.illumination)
    }
    
    func solarData(_ date: Date, waypoint: Waypoint) -> SolarData {
        return SolarData(sunrise: self.dawn?.actual,
                         sunset: self.dusk?.actual,
                         daylight: self.daylight,
                         astronomicalDawn: self.dawn?.astronomical,
                         astronomicalDusk: self.dusk?.astronomical,
                         civilDawn: self.dawn?.civil,
                         civilDusk: self.dusk?.civil,
                         nauticalDawn: self.dawn?.nautical,
                         nauticalDusk: self.dusk?.nautical,
                         solarNoon: self.solarNoon,
                         solarMidnight: nil,
                         solarAngle: self.solarAngle,
                         morningBlueHour: self.dawn?.blueHour,
                         morningGoldenHour: self.dawn?.goldenHour,
                         eveningGoldenHour: self.dusk?.goldenHour,
                         eveningBlueHour: self.dusk?.blueHour)
    }
}
