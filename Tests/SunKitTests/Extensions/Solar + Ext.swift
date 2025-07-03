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
        return SolarData(sunrise: self.sunrise,
                         sunriseAzimuth: self.sunriseAzimuth?.value,
                         sunset: self.sunset,
                         sunsetAzimuth: self.sunsetAzimuth?.value,
                         astronomicalDawn: self.astronomicalDawn,
                         astronomicalDusk: self.astronomicalDusk,
                         civilDawn: self.civilDawn,
                         civilDusk: self.civilDusk,
                         nauticalDawn: self.nauticalDawn,
                         nauticalDusk: self.nauticalDusk,
                         solarNoon: self.solarNoon,
                         solarAngle: self.angle,
                         morningBlueHourStart: self.blueHourDawnStart,
                         morningBlueHourEnd: self.blueHourDawnEnd,
                         morningGoldenHourStart: self.goldenHourDawnStart,
                         morningGoldenHourEnd: self.goldenHourDawnEnd,
                         eveningGoldenHourStart: self.goldenHourDuskStart,
                         eveningGoldenHourEnd: self.goldenHourDuskEnd,
                         eveningBlueHourStart: self.blueHourDuskStart,
                         eveningBlueHourEnd: self.blueHourDuskEnd)
    }
}
