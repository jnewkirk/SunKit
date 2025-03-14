//
//  Lunar + Ext.swift
//  SunKit
//
//  Created by Jim Newkirk on 3/14/25.
//

import Foundation
import SunKit

extension Lunar {
    func testLunarData(_ date: Date, waypoint: Waypoint) -> TestLunarData {
        return TestLunarData(name: waypoint.name,
                             date: date,
                             latitude: waypoint.latitude,
                             longitude: waypoint.longitude,
                             tzIdentifier: waypoint.timeZone.identifier,
                             lunarData: lunarData(date, waypoint: waypoint))
    }
    
    func lunarData(_ date: Date, waypoint: Waypoint) -> LunarData {
        return LunarData(rise: self.rise,
                         set: self.set,
                         angle: self.angle,
                         phase: self.phase,
                         illumination: self.illumination)
    }
}
