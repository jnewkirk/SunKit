//
//  SolarInterval.swift
//  SunKit
//
//  Created by Jim Newkirk on 4/17/25.
//

import Foundation

public struct SolarInterval : Sendable {
    public let from: SolarEvent
    public let to: SolarEvent
    
    public static var blueHourDawn: SolarInterval { SolarInterval(from: SolarEvent.civilDawn, to: SolarEvent.blueHourEndDawn) }
    public static var blueHourDusk: SolarInterval { SolarInterval(from: SolarEvent.blueHourStartDusk, to: SolarEvent.civilDusk) }
    public static var goldenHourDawn: SolarInterval { SolarInterval(from: SolarEvent.blueHourEndDawn, to: SolarEvent.goldenHourEndDawn) }
    public static var goldenHourDusk: SolarInterval { SolarInterval(from: SolarEvent.goldenHourStartDusk, to: SolarEvent.blueHourStartDusk) }
    public static var daylight: SolarInterval { SolarInterval(from: SolarEvent.sunrise, to: SolarEvent.sunset) }
}
